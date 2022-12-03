resource "azurerm_network_interface" "gcc_linux_vm_nics" {
  for_each            = var.gcc_linux_vm_nics
  name                = each.value["name"]
  location            = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                          = each.value["ip_config_name"]
    subnet_id                     = azurerm_subnet.gcc_subnets[each.value["subnet_key"]].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_resource_group.gcc_resource_groups,
    azurerm_subnet.gcc_subnets
  ]
}

# Create Linux forward proxy 
resource "azurerm_linux_virtual_machine" "gcc_linux_vms" {
  for_each            = var.gcc_linux_vms
  name                = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location            = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name

  size                            = each.value["size"]
  disable_password_authentication = each.value["disable_password_authentication"]
  admin_username                  = each.value["admin_username"]
  admin_password                  = each.value["admin_password"]

  os_disk {
    caching              = each.value["caching"]
    storage_account_type = each.value["storage_account_type"]
  }

  network_interface_ids = [
    azurerm_network_interface.gcc_linux_vm_nics[each.value["nic_key"]].id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.gcc_linux_vm_nics
  ]
}

resource "azurerm_virtual_machine_extension" "gcc_linux_vm_extensions" {
  for_each             = var.gcc_linux_vm_extensions
  name                 = format("%s%s%s", each.value["name"], "-ext", random_string.random_suffix_string.result)
  virtual_machine_id   = azurerm_linux_virtual_machine.gcc_linux_vms[each.value["linux_vm_key"]].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT
    {
        "script": "${base64encode(file(each.value["extension_script"]))}"
    }
    PROT
}