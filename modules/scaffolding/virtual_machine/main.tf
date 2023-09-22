# NICs
resource "azurerm_network_interface" "vm_nics" {
  for_each            = var.vm_nics
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  ip_configuration {
    name                          = each.value.ip_config_name
    subnet_id                     = var.subnets[each.value.subnet_key].id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux virtual machines
resource "azurerm_linux_virtual_machine" "linux_vms" {
  for_each            = var.linux_vms
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  size                            = each.value.size
  disable_password_authentication = each.value.disable_password_authentication
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password

  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nics[each.value.nic_key].id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vm_nics
  ]
}

# Extensions
resource "azurerm_virtual_machine_extension" "linux_vm_extensions" {
  for_each             = var.linux_vm_extensions
  name                 = each.value.name
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vms[each.value.vm_key].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT
    {
        "script": "${base64encode(file(each.value.extension_script))}"
    }
    PROT
}

# Windows VMs
resource "azurerm_windows_virtual_machine" "windows_vms" {
  for_each            = var.windows_vms
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  size           = each.value.size
  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nics[each.value.nic_key].id
  ]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.vm_nics
  ]
}

# Extensions
resource "azurerm_virtual_machine_extension" "windows_vm_extensions" {
  for_each             = var.windows_vm_extensions
  name                 = each.value.name
  virtual_machine_id   = azurerm_windows_virtual_machine.windows_vms[each.value.vm_key].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = each.value.resource_type == "firewall" ? jsonencode({ "commandToExecute" = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.scripts[each.value.extension_script_key].rendered)}')) | Out-File -filepath script.ps1\" && powershell -ExecutionPolicy Unrestricted -File script.ps1 ${each.value.params} ${var.firewalls[each.value.firewall_key].ip_configuration[0].private_ip_address}" }) : jsonencode({ "commandToExecute" = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.scripts[each.value.extension_script_key].rendered)}')) | Out-File -filepath script.ps1\" && powershell -ExecutionPolicy Unrestricted -File script.ps1 ${each.value.params}" })
}

data "template_file" "scripts" {
  for_each = var.vm_extension_scripts
  template = file(each.value.path)
}
