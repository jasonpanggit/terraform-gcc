resource "azurerm_kubernetes_cluster" "gcc_aks_clusters" {
  for_each                = var.gcc_aks_clusters
  name                    = format("%s%s", each.value["name"], random_string.random_suffix_string.result)
  location                = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].location
  resource_group_name     = azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name
  dns_prefix              = each.value["dns_prefix"]
  private_cluster_enabled = each.value["private_cluster_enabled"]

  default_node_pool {
    name           = each.value["default_node_pool_name"]
    node_count     = each.value["default_node_pool_node_count"]
    vm_size        = each.value["default_node_pool_vm_size"]
    vnet_subnet_id = azurerm_subnet.gcc_subnets[each.value["subnet_key"]].id
  }

  network_profile {
    network_plugin    = each.value["network_profile_network_plugin"]
    outbound_type     = each.value["network_profile_outbound_type"]
    load_balancer_sku = each.value["network_profile_load_balancer_sku"]
    docker_bridge_cidr = each.value["network_profile_docker_bridge_cidr"]
    dns_service_ip     = each.value["network_profile_dns_service_ip"]
    service_cidr       = each.value["network_profile_service_cidr"]
  }

  identity {
    type = each.value["identity_type"]
  }

  depends_on = [
    azurerm_subnet.gcc_subnets
  ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "gcc_aks_clusters_private_dns_zone_vnet_links" {
  for_each = var.gcc_aks_cluster_private_dns_zone_vnet_links
  name     = format("%s%s", each.value["name"], random_string.random_suffix_string.result)

  # aks private cluster will create a new RG
  # e.g. MC_gcc-inter-rgscjm_gcc-inter-app-aks-private-clusterscjm_eastus (MC_<resource-group-name>_<aks cluster-name>)
  resource_group_name = "MC_${azurerm_resource_group.gcc_resource_groups[each.value["rg_key"]].name}_${azurerm_kubernetes_cluster.gcc_aks_clusters[each.value["aks_cluster_key"]].name}_${each.value["aks_cluster_location_name"]}"

  # ignore the dns prefix
  # e.g. private-aks-bed885d2.e90cf079-72e8-46e6-b15c-eda51f4c2c3b.privatelink.eastus.azmk8s.io
  private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.gcc_aks_clusters[each.value["aks_cluster_key"]].private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.gcc_aks_clusters[each.value["aks_cluster_key"]].private_fqdn))))
  virtual_network_id    = azurerm_virtual_network.gcc_vnets[each.value["vnet_key"]].id

  depends_on = [
    azurerm_kubernetes_cluster.gcc_aks_clusters
  ]
}