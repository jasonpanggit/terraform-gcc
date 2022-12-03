##################################################################################################################
# By default, it will scaffold h-model. If you want to scaffold other models e.g. i-model, copy variables.tf
# into a i_model.tfvar, remove the unnecessary items and do terraform apply --var-file i_model.tfvars.
# With this approach, you can have different tfvar files for different models while the code base remains the same.
# Any resources that are not part of the scaffolding should be done outside of the module. Update the module 
# output.tf if you need addtional access to the module's resources.
##################################################################################################################
module "gcc_scaffolding" {
  source = "../modules/gcc/scaffolding"

  location             = var.location
  random_string_length = var.random_string_length

  gcc_resource_groups  = var.gcc_resource_groups
  gcc_virtual_networks = var.gcc_virtual_networks
  gcc_subnets          = var.gcc_subnets
  gcc_route_tables     = var.gcc_route_tables
  gcc_vnet_peers       = var.gcc_vnet_peers

  gcc_network_security_groups             = var.gcc_network_security_groups
  gcc_network_security_group_associations = var.gcc_network_security_group_associations

  gcc_public_ips = var.gcc_public_ips
  gcc_bastions   = var.gcc_bastions
  gcc_firewalls  = var.gcc_firewalls

  gcc_linux_proxy_vm_nics = var.gcc_linux_proxy_vm_nics
  gcc_linux_proxy_vms     = var.gcc_linux_proxy_vms

  gcc_private_dns_zones = var.gcc_private_dns_zones

  gcc_private_dns_zone_apim_a_records = var.gcc_private_dns_zone_apim_a_records
  gcc_apims                           = var.gcc_apims
}