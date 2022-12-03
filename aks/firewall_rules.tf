resource "azurerm_firewall_application_rule_collection" "gcc_internet_azfw_app_rules" {
  azure_firewall_name = module.gcc_scaffolding.gcc_firewalls["gcc_internet_azfw"].name
  resource_group_name = module.gcc_scaffolding.gcc_resource_groups["gcc_internet_rg"].name
  name                = "aks-app-rules"
  priority            = "100"
  action              = "Allow"

  rule {
    name             = "allow-aks-fqdn"
    source_addresses = ["*"]
    fqdn_tags        = ["AzureKubernetesService"]
  }

  depends_on = [
    module.gcc_scaffolding.gcc_firewalls
  ]
}