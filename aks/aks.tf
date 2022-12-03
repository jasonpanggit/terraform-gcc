# https://itnext.io/create-a-fully-private-aks-infrastructure-with-terraform-e92358f0bf65

resource "azurerm_kubernetes_cluster" "gcc_internet_app_aks_private_cluster" {
  name                = format("aks-private-cluster%s", module.gcc_scaffolding.random_string)
  location            = module.gcc_scaffolding.gcc_resource_groups["gcc_internet_rg"].location
  resource_group_name = module.gcc_scaffolding.gcc_resource_groups["gcc_internet_rg"].name
  dns_prefix          = "private-aks"
  #dns_prefix_private_cluster    = var.aks_dns_prefix_private_cluster
  #sku_tier                      = var.aks_sku_tier
  #kubernetes_version            = var.aks_kubernetes_version
  private_cluster_enabled = true
  #private_dns_zone_id           = var.aks_private_dns_zone_id
  #public_network_access_enabled = false

  network_profile {
    network_plugin     = "azure"
    outbound_type      = "userDefinedRouting"
    load_balancer_sku  = "standard"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.41.0.10"
    service_cidr       = "10.41.0.0/24"
  }

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = module.gcc_scaffolding.gcc_subnets["gcc_internet_aks_subnet"].id
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    module.gcc_scaffolding.gcc_subnets
  ]
}

# https://github.com/Azure/AKS/issues/1557
resource "azurerm_role_assignment" "jumphost_vm_contributor" {
  role_definition_name = "Virtual Machine Contributor"
  scope                = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].id
  principal_id         = azurerm_kubernetes_cluster.gcc_internet_app_aks_private_cluster.identity[0].principal_id

  depends_on = [
    module.gcc_scaffolding.gcc_resource_groups
  ]
}

resource "azurerm_network_interface" "gcc_hub_jumpbox_vm_nics" {
  name                = format("gcc-hub-jumpbox-vm-nic%s", module.gcc_scaffolding.random_string)
  location            = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].location
  resource_group_name = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].name

  ip_configuration {
    name                          = format("gcc-hub-jumpbox-vm-nic-ipconfig%s", module.gcc_scaffolding.random_string)
    subnet_id                     = module.gcc_scaffolding.gcc_subnets["gcc_hub_jumphost_subnet"].id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    module.gcc_scaffolding.gcc_resource_groups,
    module.gcc_scaffolding.gcc_subnets
  ]
}

resource "azurerm_linux_virtual_machine" "gcc_hub_jumpbox_vm" {
  name                            = format("gcc-hub-jumpbox-vm%s", module.gcc_scaffolding.random_string)
  location                        = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].location
  resource_group_name             = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].name
  network_interface_ids           = [azurerm_network_interface.gcc_hub_jumpbox_vm_nics.id]
  size                            = "Standard_B1ms"
  computer_name                   = "jumpbox-vm"
  admin_username                  = "adminuser"
  admin_password                  = "P@55w0rd1234"
  disable_password_authentication = false

  os_disk {
    name                 = "jumpboxOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # provisioner "remote-exec" {
  #   connection {
  #     host     = self.public_ip_address
  #     type     = "ssh"
  #     user     = "adminuser"
  #     password = "P@55w0rd1234"
  #   }

  #   inline = [
  #     "sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2",
  #     "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y kubectl",
  #     "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
  #   ]
  # }

  depends_on = [
    azurerm_network_interface.gcc_hub_jumpbox_vm_nics
  ]
}

resource "azurerm_virtual_machine_extension" "gcc_hub_jumpbox_vm_setup" {
  name                = format("%s%s", "gcc-hub-jumpbox-vm-ext", random_string.random_suffix_string.result)
  location                        = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].location
  resource_group_name             = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].name
  
  virtual_machine_id = azurerm_linux_virtual_machine.gcc_hub_jumpbox_vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.1"
  settings = <<SETTINGS
  {
      "fileUris": [
          "https://raw.githubusercontent.com/jasonpanggit/terraform-gcc/main/scripts/jumphost_setup/aks_jumphost_setup.sh"
          ],
      "commandToExecute": "./aks_jumphost_setup.sh"
  }
  SETTINGS
}

resource "azurerm_private_dns_zone_virtual_network_link" "gcc_hub_private_dns_zone_vnet_link" {
  name                  = format("gcc-hub-private-dns-vnet-link%s", module.gcc_scaffolding.random_string)
  resource_group_name   = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].name
  private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.gcc_internet_app_aks_private_cluster.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.gcc_internet_app_aks_private_cluster.private_fqdn))))
  virtual_network_id    = module.gcc_scaffolding.gcc_vnets["gcc_hub_vnet"].id

  depends_on = [
    module.gcc_scaffolding.gcc_resource_groups,
    module.gcc_scaffolding.gcc_vnets
  ]
}