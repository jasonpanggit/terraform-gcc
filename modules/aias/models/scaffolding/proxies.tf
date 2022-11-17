
/*
resource "azurerm_public_ip" "aias_internet_gut_proxy_vm_ip" {
  name                = var.aias_internet_gut_proxy_vm_ip_name
  location            = var.aias_internet_location
  resource_group_name = var.aias_internet_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "aias_intranet_gut_proxy_vm_ip" {
  name                = var.aias_intranet_gut_proxy_vm_ip_name
  location            = var.aias_intranet_location
  resource_group_name = var.aias_intranet_resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}
*/

resource "azurerm_network_interface" "aias_linux_vm_nics" {
  for_each            = var.aias_linux_vm_nics
  name                = each.value["name"]
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  ip_configuration {
    name                          = each.value["ip_config_name"]
    subnet_id                     = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.aias_internet_gut_proxy_vm_ip.id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_subnet.aias_subnets
    #azurerm_public_ip.aias_internet_gut_proxy_vm_ip
  ]
}
/*
resource "azurerm_network_interface" "aias_intranet_gut_proxy_vm_nic" {
  name                = var.aias_intranet_gut_proxy_vm_nic_name
  location            = azurerm_resource_group.aias_intranet_rg.location
  resource_group_name = azurerm_resource_group.aias_intranet_rg.name

  ip_configuration {
    name                          = var.aias_intranet_gut_proxy_vm_nic_ip_config_name
    subnet_id                     = module.aias_intranet_vnet.vnet_subnets_id[3]
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id = azurerm_public_ip.aias_intranet_gut_proxy_vm_ip.id
  }

  depends_on = [
    module.aias_intranet_vnet
    #azurerm_public_ip.aias_intranet_gut_proxy_vm_ip
  ]
}
*/
# Create Linux forward proxy 
resource "azurerm_linux_virtual_machine" "aias_linux_vms" {
  for_each            = var.aias_linux_vms
  name                = "${each.value["name"]}${var.random_string}"
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  size                            = each.value["size"]
  disable_password_authentication = each.value["disable_password_authentication"] #false
  admin_username                  = each.value["admin_username"]                  #var.aias_internet_gut_proxy_vm_admin_username
  admin_password                  = each.value["admin_password"]                  #var.aias_internet_gut_proxy_vm_admin_password

  os_disk {
    caching              = each.value["caching"]              #var.aias_internet_gut_proxy_vm_caching
    storage_account_type = each.value["storage_account_type"] #var.aias_internet_gut_proxy_vm_storage_account_type
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

/*
resource "azurerm_linux_virtual_machine" "aias_intranet_gut_proxy_vm" {
  name                = var.aias_intranet_gut_proxy_vm_name
  location            = azurerm_resource_group.aias_intranet_rg.location
  resource_group_name = azurerm_resource_group.aias_intranet_rg.name

  size                            = var.aias_intranet_gut_proxy_vm_size
  disable_password_authentication = false
  admin_username                  = var.aias_intranet_gut_proxy_vm_admin_username
  admin_password                  = var.aias_intranet_gut_proxy_vm_admin_password

  os_disk {
    caching              = var.aias_intranet_gut_proxy_vm_caching
    storage_account_type = var.aias_intranet_gut_proxy_vm_storage_account_type
  }

  network_interface_ids = [
    azurerm_network_interface.aias_intranet_gut_proxy_vm_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
*/
/*
  provisioner "file" {
    source      = "scripts/squid_setup.sh"
    destination = "/home/${self.admin_username}/squid_setup.sh"

    # use this if you are deploying publicly
    connection {
      type     = "ssh"
      user     = "${self.admin_username}"
      password = "${self.admin_password}"
      host     = "${azurerm_network_interface.aias_intranet_gut_proxy_vm_nic.private_ip_address}"
      agent    = false
      timeout  = "10m"
    }
    # use this if you are deploying privately within the vnet
    connection {
      type     = "ssh"
      user     = self.admin_username
      password = self.admin_password
      host     = azurerm_public_ip.aias_intranet_gut_proxy_vm_ip.ip_address
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
      host     = "${azurerm_network_interface.aias_intranet_gut_proxy_vm_nic.private_ip_address}"
      agent    = false
      timeout  = "10m"
    }
    # use this if you are deploying privately within the vnet
    connection {
      type     = "ssh"
      user     = self.admin_username
      password = self.admin_password
      host     = azurerm_public_ip.aias_intranet_gut_proxy_vm_ip.ip_address
    }
  }
*/
/*
  depends_on = [
    azurerm_network_interface.aias_intranet_gut_proxy_vm_nic
    #azurerm_public_ip.aias_intranet_gut_proxy_vm_ip
  ]
}
*/
/*
resource "azurerm_route_table" "aias_internet_firewall_route_table" {
  name                = var.aias_internet_firewall_route_table_name
  location            = azurerm_resource_group.aias_internet_rg.location
  resource_group_name = azurerm_resource_group.aias_internet_rg.name

  disable_bgp_route_propagation = false

  route {
    name                   = var.aias_internet_firewall_inter_gut_proxy_route_name
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.aias_internet_azfw.ip_configuration[0].private_ip_address
  }

  depends_on = [
    azurerm_firewall.aias_internet_azfw
  ]
}

resource "azurerm_subnet_route_table_association" "aias_internet_firewall_route_table_association" {
  subnet_id      = module.aias_internet_vnet.vnet_subnets_id[4]
  route_table_id = azurerm_route_table.aias_internet_firewall_route_table.id

  depends_on = [
    module.aias_internet_vnet,
    azurerm_route_table.aias_internet_firewall_route_table
  ]
}
*/