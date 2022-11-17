##################################################################################################################
# By default, it will scaffold h-model. If you want to scaffold other models e.g. i-model, copy variables.tf
# into a i_model.tfvar, remove the unnecessary items and do terraform apply --var-file i_model.tfvars.
# With this approach, you can have different tfvar files for different models while the code base remains the same.
# Any resources that are not part of the scaffolding should be done outside of the module. Update the module 
# output.tf if you need addtional access to the module's resources.
##################################################################################################################
module "aias_model" {
  source = "./modules/aias/models/scaffolding"

  location             = var.location
  random_string_length = var.random_string_length

  aias_resource_groups  = var.aias_resource_groups
  aias_virtual_networks = var.aias_virtual_networks
  aias_subnets          = var.aias_subnets
  aias_route_tables     = var.aias_route_tables
  aias_vnet_peers       = var.aias_vnet_peers

  aias_network_security_groups             = var.aias_network_security_groups
  aias_network_security_group_associations = var.aias_network_security_group_associations

  aias_public_ips = var.aias_public_ips
  aias_bastions   = var.aias_bastions
  aias_firewalls  = var.aias_firewalls

  aias_linux_vm_nics = var.aias_linux_vm_nics
  aias_linux_vms     = var.aias_linux_vms

  aias_private_dns_zones = var.aias_private_dns_zones

  aias_private_dns_zone_apim_a_records = var.aias_private_dns_zone_apim_a_records
  aias_apims                           = var.aias_apims
}