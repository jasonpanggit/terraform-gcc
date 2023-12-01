# resource "azurerm_user_assigned_identity" "aks_user_assigned_identity" {
#   for_each            = var.aks_clusters
#   location            = var.resource_groups[each.value.rg_key].location
#   resource_group_name = var.resource_groups[each.value.rg_key].name
#   name                = each.value.user_assigned_identity_name
# }

# AKS clusters
resource "azurerm_kubernetes_cluster" "aks_clusters" {
  for_each            = var.aks_clusters
  name                = format("%s-%s", each.value.name, var.random_string)
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name

  kubernetes_version      = each.value.kubernetes_version
  dns_prefix              = each.value.dns_prefix
  private_dns_zone_id     = var.private_dns_zones[each.value.private_dns_zone_key].id
  private_cluster_enabled = each.value.private_cluster_enabled
  #enable_rbac             = each.value.enable_rbac
  #oidc_issuer_enabled     = each.value.oidc_issuer_enabled
  #workload_identity_enabled = each.value.workload_identity_enabled
  #private_cluster_public_fqdn_enabled = each.value.private_cluster_public_fqdn_enabled

  identity {
    # TODO: use user assigned identity
    type         = each.value.identity_type
    identity_ids = each.value.identity_type == "SystemAssigned" ? [] : [azurerm_user_assigned_identity.user_assigned_identities[each.value.user_assigned_identity_key].id]
  }

  network_profile {
    network_plugin = each.value.network_profile_network_plugin
    #network_plugin_mode = each.value.network_plugin_mode
    outbound_type     = each.value.network_profile_outbound_type
    load_balancer_sku = each.value.network_profile_load_balancer_sku
    #docker_bridge_cidr = each.value.network_profile_docker_bridge_cidr
    dns_service_ip = each.value.network_profile_dns_service_ip
    service_cidr   = each.value.network_profile_service_cidr
    #pod_cidr       = each.value.network_profile_pod_cidr
  }

  default_node_pool {
    name       = each.value.default_node_pool_name
    node_count = each.value.default_node_pool_node_count
    vm_size    = each.value.default_node_pool_vm_size
    #type       = "VirtualMachineScaleSets"
    # zones               = each.value.default_node_pool_zones

    # max_pods            = each.value.default_node_pool_max_pods
    # os_disk_size_gb     = each.value.default_node_pool_os_disk_size_gb
    vnet_subnet_id = var.subnets[each.value.subnet_key].id
    # node_taints         = each.value.default_node_pool.taints
    # enable_auto_scaling = each.value.default_node_pool.cluster_auto_scaling
    # min_count           = each.value.default_node_pool.cluster_auto_scaling_min_count
    # max_count           = each.value.default_node_pool.cluster_auto_scaling_max_count
  }

  # linux_profile {
  #   admin_username = "adminuser"
  #   ssh_key {
  #     key_data = each.value.ssh_key
  #   }
  # }

  # dynamic "http_proxy_config" {
  #   for_each = each.value.proxy_settings
  #   content {
  #     http_proxy  = replace(http_proxy_config.value.http_proxy, "<vm-ip>", var.linux_vms[each.value.vm_key].private_ip_address)
  #     https_proxy = replace(http_proxy_config.value.https_proxy, "<vm-ip>", var.linux_vms[each.value.vm_key].private_ip_address)
  #   }
  # }

  depends_on = [
    azurerm_user_assigned_identity.user_assigned_identities,
    azurerm_role_assignment.aks_private_dns_zone_contributor_role_assignment
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_node_pools" {
  for_each              = var.aks_cluster_node_pools
  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_clusters[each.value.cluster_key].id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  # zones                 = each.value.zones
  mode = each.value.mode
  # max_pods              = each.value.max_pods

  # os_sku          = each.value.os_sku
  # os_type         = each.value.os_type
  # os_disk_size_gb = each.value.os_disk_size_gb

  # node_taints         = each.value.node_taints
  # enable_auto_scaling = each.value.enable_auto_scaling
  # min_count           = each.value.min_count
  # max_count           = each.value.max_count

  vnet_subnet_id = var.subnets[each.value.subnet_key].id

  depends_on = [
    azurerm_kubernetes_cluster.aks_clusters
  ]
}

# resource "azurerm_private_dns_zone_virtual_network_link" "aks_cluster_private_dns_zone_vnet_links" {
#   for_each = var.aks_cluster_private_dns_zone_vnet_links
#   name     = format("%s-%s", each.value.name, var.random_string)

#   # aks private cluster will create a new RG
#   # e.g. MC_gcc-inter-rgscjm_gcc-inter-app-aks-private-clusterscjm_eastus (MC_<resource-group-name>_<aks cluster-name>)
#   resource_group_name = "MC_${var.resource_groups[each.value.rg_key].name}_${azurerm_kubernetes_cluster.aks_clusters[each.value.aks_cluster_key].name}_${each.value.aks_cluster_location_name}"

#   # ignore the dns prefix
#   # e.g. private-aks-bed885d2.e90cf079-72e8-46e6-b15c-eda51f4c2c3b.privatelink.eastus.azmk8s.io
#   private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.aks_clusters[each.value.aks_cluster_key].private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.aks_clusters[each.value.aks_cluster_key].private_fqdn))))
#   virtual_network_id    = var.virtual_networks[each.value.vnet_key].id

#   depends_on = [
#     azurerm_kubernetes_cluster.aks_clusters
#   ]
# }

resource "azurerm_user_assigned_identity" "user_assigned_identities" {
  for_each            = var.user_assigned_identities
  name                = each.value.name
  location            = var.resource_groups[each.value.rg_key].location
  resource_group_name = var.resource_groups[each.value.rg_key].name
}

resource "azurerm_role_assignment" "aks_private_dns_zone_contributor_role_assignment" {
  for_each             = var.aks_clusters
  scope                = var.private_dns_zones[each.value.private_dns_zone_key].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identities[each.value.user_assigned_identity_key].principal_id

  depends_on = [
    azurerm_user_assigned_identity.user_assigned_identities
  ]
}