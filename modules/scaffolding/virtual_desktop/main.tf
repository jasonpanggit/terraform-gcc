resource "azurerm_virtual_desktop_workspace" "virtual_desktop_workspace" {
  location            = var.resource_groups[var.virtual_desktop_workspace.rg_key].location
  resource_group_name = var.resource_groups[var.virtual_desktop_workspace.rg_key].name
  name                = var.virtual_desktop_workspace.name
  friendly_name       = var.virtual_desktop_workspace.friendly_name
  description         = var.virtual_desktop_workspace.description
}

resource "azurerm_virtual_desktop_host_pool" "virtual_desktop_host_pool" {
  location              = var.resource_groups[var.virtual_desktop_host_pool.rg_key].location
  resource_group_name   = var.resource_groups[var.virtual_desktop_host_pool.rg_key].name
  name                  = var.virtual_desktop_host_pool.name
  friendly_name         = var.virtual_desktop_host_pool.friendly_name
  validate_environment  = var.virtual_desktop_host_pool.validate_environment
  start_vm_on_connect   = var.virtual_desktop_host_pool.start_vm_on_connect
  custom_rdp_properties = var.virtual_desktop_host_pool.custom_rdp_properties
  description           = var.virtual_desktop_host_pool.description
  type                  = var.virtual_desktop_host_pool.type
  #personal_desktop_assignment_type = var.virtual_desktop_host_pool.personal_desktop_assignment_type
  load_balancer_type       = var.virtual_desktop_host_pool.load_balancer_type
  maximum_sessions_allowed = var.virtual_desktop_host_pool.maximum_sessions_allowed
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "virtual_desktop_host_pool_registration_info" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pool.id
  expiration_date = time_rotating.avd_registration_expiration.rotation_rfc3339
}

resource "azurerm_virtual_desktop_application_group" "virtual_desktop_desktop_application_group" {
  location            = var.resource_groups[var.virtual_desktop_desktop_application_group.rg_key].location
  resource_group_name = var.resource_groups[var.virtual_desktop_desktop_application_group.rg_key].name
  name                = var.virtual_desktop_desktop_application_group.name
  type                = var.virtual_desktop_desktop_application_group.type
  host_pool_id        = azurerm_virtual_desktop_host_pool.virtual_desktop_host_pool.id
  friendly_name       = var.virtual_desktop_desktop_application_group.friendly_name
  description         = var.virtual_desktop_desktop_application_group.description
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "virtual_desktop_desktop_application_group_association" {
  workspace_id         = azurerm_virtual_desktop_workspace.virtual_desktop_workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_group.id

  depends_on = [azurerm_virtual_desktop_workspace.virtual_desktop_workspace, azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_group]
}

resource "azurerm_network_interface" "virtual_desktop_aadj_vm_nics" {
  count               = var.virtual_desktop_aadj_vms.count
  name                = "${var.virtual_desktop_aadj_vms.prefix}-${count.index + 1}-nic"
  location            = var.resource_groups[var.virtual_desktop_aadj_vms.rg_key].location
  resource_group_name = var.resource_groups[var.virtual_desktop_aadj_vms.rg_key].name

  ip_configuration {
    name                          = "nic${count.index + 1}-config"
    subnet_id                     = var.subnets[var.virtual_desktop_aadj_vms.subnet_key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual_desktop_aadj_vms" {
  count                 = var.virtual_desktop_aadj_vms.count
  name                  = "${var.virtual_desktop_aadj_vms.prefix}-${count.index + 1}"
  location              = var.resource_groups[var.virtual_desktop_aadj_vms.rg_key].location
  resource_group_name   = var.resource_groups[var.virtual_desktop_aadj_vms.rg_key].name
  size                  = var.virtual_desktop_aadj_vms.size
  network_interface_ids = ["${azurerm_network_interface.virtual_desktop_aadj_vm_nics.*.id[count.index]}"]
  provision_vm_agent    = true
  admin_username        = var.virtual_desktop_aadj_vms.admin_username
  admin_password        = var.virtual_desktop_aadj_vms.admin_password

  os_disk {
    name                 = "${lower(var.virtual_desktop_aadj_vms.prefix)}-${count.index + 1}"
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
    azurerm_network_interface.virtual_desktop_aadj_vm_nics
  ]
}

resource "azurerm_virtual_machine_extension" "virtual_desktop_aadj_vm_aad_join_extensions" {
  count                      = var.virtual_desktop_aadj_vms.count
  name                       = "${var.virtual_desktop_aadj_vms.prefix}-${count.index + 1}-aad-join-ext"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_aadj_vms.*.id[count.index]
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [azurerm_windows_virtual_machine.virtual_desktop_aadj_vms]
}

resource "azurerm_virtual_machine_extension" "virtual_desktop_vm_extensions" {
  count                      = var.virtual_desktop_aadj_vms.count
  name                       = "${var.virtual_desktop_aadj_vms.prefix}-${count.index + 1}-dsc-ext"
  virtual_machine_id         = azurerm_windows_virtual_machine.virtual_desktop_aadj_vms.*.id[count.index]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.virtual_desktop_host_pool.name}",
        "aadJoin": true
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.virtual_desktop_host_pool_registration_info.token}"
    }
  }
PROTECTED_SETTINGS

  depends_on = [
    azurerm_virtual_machine_extension.virtual_desktop_aadj_vm_aad_join_extensions,
    azurerm_virtual_desktop_host_pool.virtual_desktop_host_pool,
    azurerm_windows_virtual_machine.virtual_desktop_aadj_vms
  ]
}

resource "azurerm_storage_account" "virtual_desktop_fslogix_storage_account" {
  location                 = var.resource_groups[var.virtual_desktop_fslogix_storage_account.rg_key].location
  resource_group_name      = var.resource_groups[var.virtual_desktop_fslogix_storage_account.rg_key].name
  name                     = format("%s%s", var.virtual_desktop_fslogix_storage_account.name, var.random_string)
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  azure_files_authentication {
    directory_type = "AADKERB"
  }
}

resource "azurerm_storage_share" "virtual_desktop_fslogix_storage_account_file_share" {
  name                 = var.virtual_desktop_fslogix_storage_account.file_share_name
  storage_account_name = azurerm_storage_account.virtual_desktop_fslogix_storage_account.name
  enabled_protocol     = var.virtual_desktop_fslogix_storage_account.enabled_protocol
  quota                = var.virtual_desktop_fslogix_storage_account.quota
  depends_on           = [azurerm_storage_account.virtual_desktop_fslogix_storage_account]
}

data "azuread_client_config" "current" {}

# create AVD user group
resource "azuread_group" "virtual_desktop_user_group" {
  display_name     = var.virtual_desktop_aadj_vms.user_group_name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

# # ## Azure built-in roles
# # ## https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
data "azurerm_role_definition" "storage_file_data_smb_share_contributor_role" {
  name = "Storage File Data SMB Share Contributor"
}
resource "azurerm_role_assignment" "virtual_desktop_fslogix_storage_account_role_assignment" {
  scope              = azurerm_storage_account.virtual_desktop_fslogix_storage_account.id
  role_definition_id = data.azurerm_role_definition.storage_file_data_smb_share_contributor_role.id
  principal_id       = azuread_group.virtual_desktop_user_group.id
}

# assign virtual machine user login role to internet resource group
data "azurerm_role_definition" "virtual_machine_user_login_role" {
  name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "virtual_desktop_user_group_vm_user_login_resource_group_role_assignment" {
  scope              = var.resource_groups[var.virtual_desktop_aadj_vms.rg_key].id
  role_definition_id = data.azurerm_role_definition.virtual_machine_user_login_role.id
  principal_id       = azuread_group.virtual_desktop_user_group.id
}

# assign user group to application group
data "azurerm_role_definition" "desktop_virtualization_user_role" {
  name = "Desktop Virtualization User"
}
resource "azurerm_role_assignment" "virtual_desktop_application_group_user_group_assignment" {
  scope              = azurerm_virtual_desktop_application_group.virtual_desktop_desktop_application_group.id
  role_definition_id = data.azurerm_role_definition.desktop_virtualization_user_role.id
  principal_id       = azuread_group.virtual_desktop_user_group.id
}

resource "time_rotating" "avd_registration_expiration" {
  # Must be between 1 hour and 30 days
  rotation_days = 29
}
