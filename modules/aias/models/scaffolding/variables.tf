/*
# internet vnet
variable "aias_internet_vnet_name" {}
variable "aias_internet_resource_group_name" {}
variable "aias_internet_location" {}
variable "aias_internet_vnet_address_space" {}
variable "aias_internet_vnet_snet_names" {}
variable "aias_internet_vnet_snet_address_prefixes" {}
#variable "aias_internet_vnet_dns_servers" {}

# intranet vnet
variable "aias_intranet_vnet_name" {}
variable "aias_intranet_resource_group_name" {}
variable "aias_intranet_location" {}
variable "aias_intranet_vnet_address_space" {}
variable "aias_intranet_vnet_snet_names" {}
variable "aias_intranet_vnet_snet_address_prefixes" {}
#variable "aias_intranet_vnet_dns_servers" {}

# mgmt vnet
variable "aias_mgmt_vnet_name" {}
variable "aias_mgmt_resource_group_name" {}
variable "aias_mgmt_location" {}
variable "aias_mgmt_vnet_address_space" {}
variable "aias_mgmt_vnet_snet_names" {}
variable "aias_mgmt_vnet_snet_address_prefixes" {}
#variable "aias_mgmt_vnet_dns_servers" {}

# nsg and rules
#variable "aias_internet_nsg_name" {}
#variable "aias_intranet_nsg_name" {}
#variable "aias_mgmt_nsg_name" {}
variable "aias_internet_gut_nsg_name" {}
variable "aias_intranet_gut_nsg_name" {}
variable "aias_internet_apim_nsg_name" {}
variable "aias_intranet_apim_nsg_name" {}
variable "aias_mgmt_bastion_nsg_name" {}

#variable "aias_internet_nsg_rules" {}
#variable "aias_intranet_nsg_rules" {}
#variable "aias_mgmt_nsg_rules" {}
variable "aias_internet_gut_nsg_rules" {}
variable "aias_intranet_gut_nsg_rules" {}
variable "aias_internet_apim_nsg_rules" {}
variable "aias_intranet_apim_nsg_rules" {}
variable "aias_mgmt_bastion_nsg_rules" {}

# vnet peering
variable "aias_internet_intranet_vnet_peer_name" {}
variable "aias_intranet_internet_vnet_peer_name" {}
variable "aias_internet_mgmt_vnet_peer_name" {}
variable "aias_mgmt_internet_vnet_peer_name" {}
variable "aias_intranet_mgmt_vnet_peer_name" {}
variable "aias_mgmt_intranet_vnet_peer_name" {}
*/
variable "random_string" {}
variable "location" {}

variable "aias_resource_groups" {
  type = any
}
variable "aias_virtual_networks" {
  type = any
}
variable "aias_vnet_peers" {
  default = {}
  type    = any
}
variable "aias_subnets" {
  type = any
}
#variable "aias_subnet_route_tables" {
#  default = {}
#  type = any
#}
variable "aias_network_security_groups" {
  default = {}
  type    = any
}
variable "aias_network_security_group_associations" {
  default = {}
  type    = any
}

# bastion
/*
variable "aias_mgmt_bastion_name" {}
variable "aias_mgmt_bastion_rg_key" {}
variable "aias_mgmt_bastion_subnet_key" {}
variable "aias_mgmt_bastion_ip_name" {}
variable "aias_mgmt_bastion_ip_config_name" {}
*/
variable "aias_bastions" {
  default = {}
  type    = any
}

variable "aias_public_ips" {
  default = {}
  type    = any
}
/*
# internet firewall
variable "aias_internet_azfw_name" {}
variable "aias_internet_azfw_ip_name" {}
variable "aias_internet_azfw_ip_config_name" {}
variable "aias_internet_azfw_sku_name" {}
variable "aias_internet_azfw_sku_tier" {}
*/
variable "aias_firewalls" {
  default = {}
  type    = any
}

/*
# proxies
variable "aias_internet_gut_proxy_vm_name" {}
variable "aias_internet_gut_proxy_vm_nic_name" {}
variable "aias_internet_gut_proxy_vm_ip_name" {}
variable "aias_internet_gut_proxy_vm_nic_ip_config_name" {}
variable "aias_internet_gut_proxy_vm_size" {}
variable "aias_internet_gut_proxy_vm_caching" {}
variable "aias_internet_gut_proxy_vm_storage_account_type" {}
variable "aias_internet_gut_proxy_vm_admin_username" {}
variable "aias_internet_gut_proxy_vm_admin_password" {}

variable "aias_intranet_gut_proxy_vm_name" {}
variable "aias_intranet_gut_proxy_vm_nic_name" {}
variable "aias_intranet_gut_proxy_vm_ip_name" {}
variable "aias_intranet_gut_proxy_vm_nic_ip_config_name" {}
variable "aias_intranet_gut_proxy_vm_size" {}
variable "aias_intranet_gut_proxy_vm_caching" {}
variable "aias_intranet_gut_proxy_vm_storage_account_type" {}
variable "aias_intranet_gut_proxy_vm_admin_username" {}
variable "aias_intranet_gut_proxy_vm_admin_password" {}
*/
variable "aias_linux_vm_nics" {
  default = {}
  type    = any
}
variable "aias_linux_vms" {
  default = {}
  type    = any
}

/*
# API management
variable "aias_internet_it_apim_name" {}
variable "aias_internet_it_apim_rg_key" {}
variable "aias_internet_it_apim_subnet_key" {}
variable "aias_internet_it_apim_publisher_name" {}
variable "aias_internet_it_apim_publisher_email" {}
variable "aias_internet_it_apim_sku_name" {}
variable "aias_internet_it_apim_sku_capacity" {}
variable "aias_internet_it_apim_type" {}

variable "aias_intranet_it_apim_name" {}
variable "aias_intranet_it_apim_rg_key" {}
variable "aias_intranet_it_apim_subnet_key" {}
variable "aias_intranet_it_apim_publisher_name" {}
variable "aias_intranet_it_apim_publisher_email" {}
variable "aias_intranet_it_apim_sku_name" {}
variable "aias_intranet_it_apim_sku_capacity" {}
variable "aias_intranet_it_apim_type" {}
*/
variable "aias_apims" {
  default = {}
  type    = any
}

# Private dns zones
#variable "aias_private_dns_zone_apim_zone_name" {}
#variable "aias_private_dns_zone_apim_endpoints" {}

variable "aias_private_dns_zones" {
  default = {}
  type    = any
}
variable "aias_private_dns_zone_apim_a_records" {
  default = {}
  type    = any
}

# route tables
#variable "aias_internet_firewall_route_table_name" {}
#variable "aias_internet_firewall_inter_gut_proxy_route_name" {}