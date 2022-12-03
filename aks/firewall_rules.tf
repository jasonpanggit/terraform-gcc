resource "azurerm_firewall_application_rule_collection" "gcc_hub_azfw_app_rules" {
  azure_firewall_name = module.gcc_scaffolding.gcc_firewalls["gcc_hub_azfw"].name
  resource_group_name = module.gcc_scaffolding.gcc_resource_groups["gcc_hub_rg"].name
  name                = "aks-app-rules"
  priority            = "100"
  action              = "Allow"

  rule {
    name             = "allow-aks-fqdn"
    source_addresses = ["*"]
    fqdn_tags        = ["AzureKubernetesService"]

    # manually set the target fqdns
    # target_fqdns = [
    #   "*.cdn.mscr.io",
    #   "mcr.microsoft.com",
    #   "*.data.mcr.microsoft.com",
    #   "management.azure.com",
    #   "login.microsoftonline.com",
    #   "acs-mirror.azureedge.net",
    #   "dc.services.visualstudio.com",
    #   "*.opinsights.azure.com",
    #   "*.oms.opinsights.azure.com",
    #   "*.microsoftonline.com",
    #   "*.monitoring.azure.com",
    # ]

    # protocol {
    #   port = "80"
    #   type = "Http"
    # }

    # protocol {
    #   port = "443"
    #   type = "Https"
    # }
  }

  depends_on = [
    module.gcc_scaffolding.gcc_firewalls
  ]
}