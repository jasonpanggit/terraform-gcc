# Random
resource "random_string" "random_suffix_string" {
  length  = var.random_string_length
  special = false
  upper   = false
  lower   = true
  numeric = false
}

# Resource groups
resource "azurerm_resource_group" "resource_groups" {
  for_each = var.resource_groups
  name     = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location = var.location

  depends_on = [
    random_string.random_suffix_string
  ]
}

# VNets
resource "azurerm_virtual_network" "virtual_networks" {
  for_each            = var.virtual_networks
  name                = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_groups[each.value["rg_key"]].name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)
  /*
  dynamic "ddos_protection_plan" {
    for_each = var.network_ddos_protection_plan
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = lookup(ddos_protection_plan.value, "enable", false)
    }
  }
  */
  tags = each.value["tags"]

  depends_on = [
    azurerm_resource_group.resource_groups
  ]
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = azurerm_resource_group.resource_groups[each.value["rg_key"]].name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = lookup(each.value, "service_endpoints", null)
  private_endpoint_network_policies_enabled = lookup(each.value, "private_endpoint_network_policies_enabled", null) #(Optional) Enable or Disable network policies for the private link endpoint on the subnet. Default valule is false. Conflicts with enforce_private_link_service_network_policies.
  private_link_service_network_policies_enabled  = lookup(each.value, "private_link_service_network_policies_enabled", null)  #(Optional) Enable or Disable network policies for the private link service on the subnet. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.
  virtual_network_name                           = azurerm_virtual_network.virtual_networks[each.value["vnet_key"]].name

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)    # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
          actions = lookup(service_delegation.value, "actions", null) # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
        }
      }
    }
  }
  depends_on = [
    azurerm_resource_group.resource_groups,
    azurerm_virtual_network.virtual_networks
  ]
}

# VNet peerings
resource "azurerm_virtual_network_peering" "vnet_peers" {
  for_each                     = var.vnet_peers
  name                         = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  virtual_network_name         = azurerm_virtual_network.virtual_networks[each.value["vnet_key"]].name
  resource_group_name          = azurerm_resource_group.resource_groups[each.value["rg_key"]].name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_networks[each.value["remote_vnet_key"]].id
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", null)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", null)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", null)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", null)

  depends_on = [
    azurerm_virtual_network.virtual_networks
  ]
}