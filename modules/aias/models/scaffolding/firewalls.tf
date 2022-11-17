resource "azurerm_firewall" "aias_firewalls" {
  for_each            = var.aias_firewalls
  name                = "${each.value["name"]}${var.random_string}"
  location            = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].location
  resource_group_name = azurerm_resource_group.aias_resource_groups[each.value["rg_key"]].name

  sku_name = each.value["sku_name"]
  sku_tier = each.value["sku_tier"]

  ip_configuration {
    name                 = "${each.value["ip_config_name"]}${var.random_string}"
    subnet_id            = azurerm_subnet.aias_subnets[each.value["subnet_key"]].id
    public_ip_address_id = azurerm_public_ip.aias_public_ips[each.value["public_ip_key"]].id
  }

  depends_on = [
    azurerm_resource_group.aias_resource_groups,
    azurerm_public_ip.aias_public_ips
  ]
}

/*
# Azure DevOps Services network rule whitelisting
resource "azurerm_firewall_network_rule_collection" "aias_internet_ingressegress_azfw_ado_nw_rule_col" {
  azure_firewall_name = azurerm_firewall.aias_internet_ingressegress_azfw.name
  resource_group_name = azurerm_resource_group.aias_rg.name
  name                = var.aias_internet_ingressegress_azfw_ado_nw_rule_col_name
  priority            = var.aias_internet_ingressegress_azfw_ado_nw_rule_col_priority
  action              = "Allow"

  rule {
    name                  = "ado_outbound_network_rule_1"
    source_addresses      = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    destination_addresses = ["13.107.6.0/24"]
    destination_ports     = [443]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "ado_outbound_network_rule_2"
    source_addresses      = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    destination_addresses = ["13.107.9.0/24"]
    destination_ports     = [443]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "ado_outbound_network_rule_3"
    source_addresses      = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    destination_addresses = ["13.107.42.0/24"]
    destination_ports     = [443]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "ado_outbound_network_rule_4"
    source_addresses      = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    destination_addresses = ["13.107.43.0/24"]
    destination_ports     = [443]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "ado_inbound_network_rule_1"
    source_addresses      = ["20.189.107.0/24"]
    destination_addresses = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    destination_ports     = [443]
    protocols             = ["TCP"]
  }

  depends_on = [azurerm_network_interface.aias_internet_gut_fproxy_vm_nic, azurerm_firewall.aias_internet_ingressegress_azfw, azurerm_resource_group.aias_rg]
}

# Azure DevOps Services application rule whitelisting
resource "azurerm_firewall_application_rule_collection" "aias_internet_ingressegress_azfw_ado_app_rule_col" {
  azure_firewall_name = azurerm_firewall.aias_internet_ingressegress_azfw.name
  resource_group_name = azurerm_resource_group.aias_rg.name
  name                = var.aias_internet_ingressegress_azfw_ado_app_rule_col_name
  priority            = var.aias_internet_ingressegress_azfw_ado_app_rule_col_priority
  action              = "Allow"

  dynamic "rule" {
    for_each = local.fw_ado_app_rules.target_fqdns
    content {
      name             = "ado_application_rules_${rule.key}"
      source_addresses = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
      target_fqdns     = ["${rule.value}"]
      protocol {
        port = local.fw_ado_app_rules.protocol_port
        type = local.fw_ado_app_rules.protocol_type
      }
    }
  }

  # organization urls
  rule {
    name             = "ado_organization_application_rules_${length(local.fw_ado_app_rules.target_fqdns) + 1}"
    source_addresses = ["${azurerm_network_interface.aias_internet_gut_fproxy_vm_nic.ip_configuration[0].private_ip_address}"]
    target_fqdns = [
      "${var.aias_internet_ingressegress_azfw_ado_org}.visualstudio.com",
      "${var.aias_internet_ingressegress_azfw_ado_org}.vsrm.visualstudio.com",
      "${var.aias_internet_ingressegress_azfw_ado_org}.vstmr.visualstudio.com",
      "${var.aias_internet_ingressegress_azfw_ado_org}.vssps.visualstudio.com"
    ]
    protocol {
      port = local.fw_ado_app_rules.protocol_port
      type = local.fw_ado_app_rules.protocol_type
    }
  }

  depends_on = [azurerm_network_interface.aias_internet_gut_fproxy_vm_nic, azurerm_firewall.aias_internet_ingressegress_azfw, azurerm_resource_group.aias_rg]
}
*/