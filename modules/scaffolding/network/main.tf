# VNets
resource "azurerm_virtual_network" "virtual_networks" {
  for_each            = var.virtual_networks
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.location
  resource_group_name = var.resource_groups[each.value.rg_key].name
  address_space       = each.value.address_space
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
  tags = each.value.tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each                                      = var.subnets
  name                                          = each.value.name
  resource_group_name                           = var.resource_groups[each.value.rg_key].name
  address_prefixes                              = each.value.address_prefixes
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  private_endpoint_network_policies_enabled     = lookup(each.value, "private_endpoint_network_policies_enabled", null)     #(Optional) Enable or Disable network policies for the private link endpoint on the subnet. Default valule is false. Conflicts with enforce_private_link_service_network_policies.
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", null) #(Optional) Enable or Disable network policies for the private link service on the subnet. Default valule is false. Conflicts with enforce_private_link_endpoint_network_policies.
  virtual_network_name                          = azurerm_virtual_network.virtual_networks[each.value.vnet_key].name

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {})
    content {
      name = delegation.key
      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }

  depends_on = [
    azurerm_virtual_network.virtual_networks
  ]
}

# VNet peerings
resource "azurerm_virtual_network_peering" "vnet_peers" {
  for_each                     = var.vnet_peers
  name                         = format("%s-%s", each.value.name, var.random_string)
  virtual_network_name         = azurerm_virtual_network.virtual_networks[each.value.vnet_key].name
  resource_group_name          = var.resource_groups[each.value.rg_key].name
  remote_virtual_network_id    = azurerm_virtual_network.virtual_networks[each.value.remote_vnet_key].id
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", null)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", null)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", null)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", null)

  depends_on = [
    azurerm_virtual_network.virtual_networks
  ]
}