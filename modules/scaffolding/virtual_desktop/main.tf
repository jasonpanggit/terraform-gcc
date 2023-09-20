resource "azurerm_virtual_desktop_workspace" "virtual_desktop_workspaces" {
  for_each            = var.virtual_desktop_workspaces
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  name                = each.value.name
  friendly_name       = each.value.friendly_name
  description         = each.value.description
}

resource "azurerm_virtual_desktop_host_pool" "virtual_desktop_host_pools" {
  for_each                 = var.virtual_desktop_host_pools
  location                 = var.resource_groups[each.value.rg_key].location
  resource_group_name      = var.resource_groups[each.value.rg_key].name
  name                     = each.value.name
  friendly_name            = each.value.friendly_name
  validate_environment     = each.value.validate_environment
  start_vm_on_connect      = each.value.start_vm_on_connect
  custom_rdp_properties    = each.value.custom_rdp_properties
  description              = each.value.description
  type                     = each.value.type
  load_balancer_type       = each.value.load_balancer_type
  maximum_sessions_allowed = each.value.maximum_sessions_allowed
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "virtual_desktop_host_pool_registration_infos" {
  for_each        = var.virtual_desktop_host_pool_registration_infos
  hostpool_id     = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[each.value.host_pool_key].id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}

resource "azurerm_virtual_desktop_application_group" "virtual_desktop_desktop_application_groups" {
  for_each            = var.virtual_desktop_desktop_application_groups
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  name                = each.value.name
  type                = each.value.type
  host_pool_id        = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[each.value.host_pool_key].id
  friendly_name       = each.value.friendly_name
  description         = each.value.description
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "virtual_desktop_desktop_application_group_association" {
  for_each             = var.virtual_desktop_desktop_application_groups
  workspace_id         = azurerm_virtual_desktop_workspace.virtual_desktop_workspaces[each.value.workspace_key].id
  application_group_id = azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_groups[each.value.application_group_key].id
}

resource "azurerm_network_interface" "virtual_desktop_vm_nics" {
  for_each            = var.virtual_desktop_vm_nics
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  ip_configuration {
    name                          = each.value.ip_config_name
    subnet_id                     = var.subnets[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual_desktop_vms" {
  for_each            = var.virtual_desktop_vms
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  size                = each.value.size
  network_interface_ids = [
    azurerm_network_interface.virtual_desktop_vm_nics[each.value.nic_key].id
  ]
  provision_vm_agent = true
  admin_username     = each.value.admin_username
  admin_password     = each.value.admin_password

  os_disk {
    name                 = "${lower(each.value.name)}-os"
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
  for_each                   = var.virtual_desktop_vm_aad_join_extensions
  name                       = each.value.name
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_vms[each.value.vm_key].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

}

resource "azurerm_virtual_machine_extension" "virtual_desktop_vm_dsc_extensions" {
  for_each                   = var.virtual_desktop_vm_dsc_extensions
  name                       = each.value.name
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_vms[each.value.vm_key].id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.virtual_desktop_host_pools[each.value.host_pool_key].name}",
        "aadJoin": true
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.virtual_desktop_host_pool_registration_infos[each.value.registration_info_key].token}"
    }
  }
PROTECTED_SETTINGS

}

resource "azurerm_storage_account" "virtual_desktop_fslogix_storage_accounts" {
  for_each                 = var.virtual_desktop_fslogix_storage_accounts
  location                 = var.resource_groups[each.value.rg_key].location
  resource_group_name      = var.resource_groups[each.value.rg_key].name
  name                     = format("%s%s", each.value.name, var.random_string)
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  azure_files_authentication {
    directory_type = "AADKERB"
  }
}

resource "azurerm_storage_share" "virtual_desktop_fslogix_storage_account_file_shares" {
  for_each             = var.virtual_desktop_fslogix_storage_accounts
  name                 = each.value.file_share_name
  storage_account_name = azurerm_storage_account.virtual_desktop_fslogix_storage_accounts[each.value.storage_account_key].name
  enabled_protocol     = each.value.file_share_enabled_protocol
  quota                = each.value.file_share_quota

  depends_on = [
    azurerm_storage_account.virtual_desktop_fslogix_storage_accounts
  ]
}

data "azuread_client_config" "current" {}

# create AVD user group
resource "azuread_group" "virtual_desktop_user_groups" {
  for_each         = var.virtual_desktop_user_groups
  display_name     = each.value.name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

# # ## Azure built-in roles
# # ## https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
data "azurerm_role_definition" "storage_file_data_smb_share_contributor_role" {
  name = "Storage File Data SMB Share Contributor"
}

resource "azurerm_role_assignment" "virtual_desktop_fslogix_storage_account_role_assignments" {
  for_each           = var.virtual_desktop_user_groups
  scope              = azurerm_storage_account.virtual_desktop_fslogix_storage_accounts[each.value.storage_account_key].id
  role_definition_id = data.azurerm_role_definition.storage_file_data_smb_share_contributor_role.id
  principal_id       = azuread_group.virtual_desktop_user_groups[each.value.user_group_key].id
}

# assign virtual machine user login role to internet resource group
data "azurerm_role_definition" "virtual_machine_user_login_role" {
  name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "virtual_desktop_user_group_vm_user_login_resource_group_role_assignments" {
  for_each           = var.virtual_desktop_user_groups
  scope              = var.resource_groups[each.value.rg_key].id
  role_definition_id = data.azurerm_role_definition.virtual_machine_user_login_role.id
  principal_id       = azuread_group.virtual_desktop_user_groups[each.value.user_group_key].id
}

# assign user group to application group
data "azurerm_role_definition" "desktop_virtualization_user_role" {
  name = "Desktop Virtualization User"
}
resource "azurerm_role_assignment" "virtual_desktop_application_group_user_group_assignment" {
  for_each           = var.virtual_desktop_user_groups
  scope              = azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_groups[each.value.application_group_key].id
  role_definition_id = data.azurerm_role_definition.desktop_virtualization_user_role.id
  principal_id       = azuread_group.virtual_desktop_user_groups[each.value.user_group_key].id

  depends_on = [
    azuread_group.virtual_desktop_user_groups,
    azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_groups
  ]
}

resource "time_rotating" "avd_registration_expiration" {
  # Must be between 1 hour and 30 days
  rotation_days = 29
}
