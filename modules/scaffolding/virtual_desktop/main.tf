resource "azurerm_virtual_desktop_workspace" "virtual_desktop_workspaces" {
  for_each            = var.virtual_desktop_workspaces
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  name                = each.value.name
  friendly_name       = each.value.friendly_name
  description         = each.value.description
}

resource "azurerm_virtual_desktop_host_pool" "virtual_desktop_host_pools" {
  for_each              = var.virtual_desktop_host_pools
  location              = var.resource_groups[each.value.rg_key].location
  resource_group_name   = var.resource_groups[each.value.rg_key].name
  name                  = each.value.name
  friendly_name         = each.value.friendly_name
  validate_environment  = each.value.validate_environment
  start_vm_on_connect   = each.value.start_vm_on_connect
  custom_rdp_properties = each.value.custom_rdp_properties
  description           = each.value.description
  type                  = each.value.type
  #personal_desktop_assignment_type = each.value.personal_desktop_assignment_type
  load_balancer_type       = each.value.load_balancer_type
  maximum_sessions_allowed = each.value.maximum_sessions_allowed

  # dynamic "scheduled_agent_updates" {
  #   for_each = each.value.scheduled_agent_updates
  #   content {
  #     enabled = scheduled_agent_updates.value.enabled
  #     schedule {
  #       day_of_week = scheduled_agent_updates.value.schedule.day_of_week
  #       hour_of_day = scheduled_agent_updates.value.schedule.hour_of_day
  #     }
  #   }
  # }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "virtual_desktop_host_pool_registration_infos" {
  for_each        = var.virtual_desktop_host_pools
  hostpool_id     = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[each.value.host_pool_key].id
  expiration_date = time_rotating.avd_token.rotation_rfc3339
}

resource "azurerm_virtual_desktop_application_group" "virtual_desktop_application_groups" {
  for_each            = var.virtual_desktop_application_groups
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  name                = each.value.name
  type                = each.value.type
  host_pool_id        = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[each.value.host_pool_key].id
  friendly_name       = each.value.friendly_name
  description         = each.value.description
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "virtual_desktop_application_group_associations" {
  for_each             = var.virtual_desktop_application_group_associations
  workspace_id         = azurerm_virtual_desktop_workspace.virtual_desktop_workspaces[each.value.workspace_key].id
  application_group_id = azurerm_virtual_desktop_application_group.virtual_desktop_application_groups[each.value.application_group_key].id

  depends_on = [azurerm_virtual_desktop_workspace.virtual_desktop_workspaces, azurerm_virtual_desktop_application_group.virtual_desktop_application_groups]
}

resource "azurerm_network_interface" "virtual_desktop_vm_nics" {
  count               = var.virtual_desktop_vms.count
  name                = "${var.virtual_desktop_vms.prefix}-${count.index + 1}-nic"
  location            = var.resource_groups[var.virtual_desktop_vms.rg_key].location
  resource_group_name = var.resource_groups[var.virtual_desktop_vms.rg_key].name

  ip_configuration {
    name                          = "nic${count.index + 1}-config"
    subnet_id                     = var.subnets[var.virtual_desktop_vms.subnet_key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual_desktop_vms" {
  #for_each              = var.virtual_desktop_vms
  count                 = var.virtual_desktop_vms.count
  name                  = "${var.virtual_desktop_vms.prefix}-${count.index + 1}"
  location              = var.resource_groups[var.virtual_desktop_vms.rg_key].location
  resource_group_name   = var.resource_groups[var.virtual_desktop_vms.rg_key].name
  size                  = var.virtual_desktop_vms.size
  network_interface_ids = ["${azurerm_network_interface.virtual_desktop_vm_nics.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.virtual_desktop_vms.admin_username
  admin_password        = var.virtual_desktop_vms.admin_password

  os_disk {
    name                 = "${lower(var.virtual_desktop_vms.prefix)}-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-22h2-avd"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_network_interface.virtual_desktop_vm_nics
  ]
}

resource "azurerm_virtual_machine_extension" "virtual_desktop_vm_aad_join_extensions" {
  count                      = var.virtual_desktop_vms.count
  name                       = "${var.virtual_desktop_vms.prefix}-${count.index + 1}-aad-join-ext"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_vms.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_windows_virtual_machine.virtual_desktop_vms]
}

resource "azurerm_virtual_machine_extension" "virtual_desktop_vm_extensions" {
  count                      = var.virtual_desktop_vms.count
  name                       = "${var.virtual_desktop_vms.prefix}-${count.index + 1}-dsc-ext"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_vms.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[var.virtual_desktop_vms.host_pool_key].name}",
        "aadJoin": true
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.virtual_desktop_host_pool_registration_infos[var.virtual_desktop_vms.registration_info_key].token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.virtual_desktop_vm_aad_join_extensions,
    azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools,
    azurerm_windows_virtual_machine.virtual_desktop_vms
  ]
}

resource "time_rotating" "avd_token" {
  rotation_days = 30
}