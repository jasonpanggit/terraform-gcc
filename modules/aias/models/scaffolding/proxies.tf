resource "azurerm_network_interface" "aias_linux_vm_nics" {
  for_each            = var.aias_linux_vm_nics
  name                = each.value["name"]
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                          = each.value["ip_config_name"]
    subnet_id                     = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
  ]
}

# Create Linux forward proxy 
resource "azurerm_linux_virtual_machine" "aias_linux_vms" {
  for_each            = var.aias_linux_vms
  name                = "${each.value["name"]}${random_string.random_suffix_string.result}"
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  size                            = each.value["size"]
  disable_password_authentication = each.value["disable_password_authentication"]
  admin_username                  = each.value["admin_username"]
  admin_password                  = each.value["admin_password"]

  os_disk {
    caching              = each.value["caching"]
    storage_account_type = each.value["storage_account_type"]
  }

  network_interface_ids = [
    azurerm_network_interface.aias_linux_vm_nics[each.value["nic_key"]].id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  /*
  provisioner "file" {
    source      = "scripts/squid_setup.sh"
    destination = "/home/${self.admin_username}/squid_setup.sh"
    
    # use this if you are deploying publicly
    connection {
      type     = "ssh"
      user     = "${self.admin_username}"
      password = "${self.admin_password}"
      host     = "${azurerm_network_interface.aias_internet_gut_proxy_vm_nic.private_ip_address}"
      agent    = false
      timeout  = "10m"
    }
    # use this if you are deploying privately within the vnet
    connection {
      type     = "ssh"
      user     = self.admin_username
      password = self.admin_password
      host     = azurerm_public_ip.aias_internet_gut_proxy_vm_ip.ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/${self.admin_username}",
      "chmod +x /home/${self.admin_username}/squid_setup.sh",
      "sudo ./squid_setup.sh"
    ]

    # use this if you are deploying publicly
    connection {
      type     = "ssh"
      user     = "${self.admin_username}"
      password = "${self.admin_password}"
      host     = "${azurerm_network_interface.aias_internet_gut_proxy_vm_nic.private_ip_address}"
      agent    = false
      timeout  = "10m"
    }
    # use this if you are deploying privately within the vnet
    connection {
      type     = "ssh"
      user     = self.admin_username
      password = self.admin_password
      host     = azurerm_public_ip.aias_internet_gut_proxy_vm_ip.ip_address
    }
  }
*/

  depends_on = [
    azurerm_network_interface.aias_linux_vm_nics
  ]
}