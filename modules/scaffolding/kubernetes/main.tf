# AKS clusters
resource "azurerm_kubernetes_cluster" "aks_clusters" {
  for_each                = var.aks_clusters
  name                    = format("%s%s", each.value["name"], var.random_string)
  location                = var.resource_groups[each.value["rg_key"]].location
  resource_group_name     = var.resource_groups[each.value["rg_key"]].name
  dns_prefix              = each.value["dns_prefix"]
  private_cluster_enabled = each.value["private_cluster_enabled"]

  default_node_pool {
    name           = each.value["default_node_pool_name"]
    node_count     = each.value["default_node_pool_node_count"]
    vm_size        = each.value["default_node_pool_vm_size"]
    vnet_subnet_id = var.subnets[each.value["subnet_key"]].id
  }

  network_profile {
    network_plugin     = each.value["network_profile_network_plugin"]
    outbound_type      = each.value["network_profile_outbound_type"]
    load_balancer_sku  = each.value["network_profile_load_balancer_sku"]
    docker_bridge_cidr = each.value["network_profile_docker_bridge_cidr"]
    dns_service_ip     = each.value["network_profile_dns_service_ip"]
    service_cidr       = each.value["network_profile_service_cidr"]
  }

  dynamic "http_proxy_config" {
    for_each = each.value["proxy_settings"]
    content {
      http_proxy  = replace(http_proxy_config.value["http_proxy"], "<vm-ip>", var.linux_vms[each.value["vm_key"]].private_ip_address)
      https_proxy = replace(http_proxy_config.value["https_proxy"], "<vm-ip>", var.linux_vms[each.value["vm_key"]].private_ip_address)
    }
  }

  identity {
    type = each.value["identity_type"]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_cluster_private_dns_zone_vnet_links" {
  for_each = var.aks_cluster_private_dns_zone_vnet_links
  name     = format("%s%s", each.value["name"], var.random_string)

  # aks private cluster will create a new RG
  # e.g. MC_gcc-inter-rgscjm_gcc-inter-app-aks-private-clusterscjm_eastus (MC_<resource-group-name>_<aks cluster-name>)
  resource_group_name = "MC_${var.resource_groups[each.value["rg_key"]].name}_${azurerm_kubernetes_cluster.aks_clusters[each.value["aks_cluster_key"]].name}_${each.value["aks_cluster_location_name"]}"

  # ignore the dns prefix
  # e.g. private-aks-bed885d2.e90cf079-72e8-46e6-b15c-eda51f4c2c3b.privatelink.eastus.azmk8s.io
  private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.aks_clusters[each.value["aks_cluster_key"]].private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.aks_clusters[each.value["aks_cluster_key"]].private_fqdn))))
  virtual_network_id    = var.virtual_networks[each.value["vnet_key"]].id

  depends_on = [
    azurerm_kubernetes_cluster.aks_clusters
  ]
}