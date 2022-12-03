variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

# Random string length
variable "random_string_length" {
  default = 4
}

# Location
variable "location" {
  default = "East US"
}

# Storage account type
variable "storage_account_type" {
  default = "Standard_LRS"
}

# Resource groups
variable "gcc_resource_groups" {
  default = {
    gcc_internet_rg = {
      name = "gcc-inter-rg"
    }

    gcc_intranet_rg = {
      name = "gcc-intra-rg"
    }

    gcc_mgmt_rg = {
      name = "gcc-mgmt-rg"
    }
  }
}

# Virtual networks
variable "gcc_virtual_networks" {
  default = {
    gcc_internet_vnet = {
      rg_key        = "gcc_internet_rg"
      name          = "gcc-inter-vnet"
      address_space = ["10.0.0.0/16"]
      tags          = {}
    }

    gcc_intranet_vnet = {
      rg_key        = "gcc_intranet_rg"
      name          = "gcc-intra-vnet"
      address_space = ["10.1.0.0/16"]
      tags          = {}
    }

    gcc_mgmt_vnet = {
      rg_key        = "gcc_mgmt_rg"
      name          = "gcc-mgmt-vnet"
      address_space = ["10.2.0.0/16"]
      tags          = {}
    }
  }
}

# Virtual network peerings
variable "gcc_vnet_peers" {
  default = {
    internet_intranet_vnet_peer = {
      rg_key                       = "gcc_internet_rg"
      vnet_key                     = "gcc_internet_vnet"
      remote_vnet_key              = "gcc_intranet_vnet"
      name                         = "gcc-inter-intra-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    intranet_internet_vnet_peer = {
      rg_key                       = "gcc_intranet_rg"
      vnet_key                     = "gcc_intranet_vnet"
      remote_vnet_key              = "gcc_internet_vnet"
      name                         = "gcc-intra-inter-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    internet_mgmt_vnet_peer = {
      rg_key                       = "gcc_internet_rg"
      vnet_key                     = "gcc_internet_vnet"
      remote_vnet_key              = "gcc_mgmt_vnet"
      name                         = "gcc-inter-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    mgmt_internet_vnet_peer = {
      rg_key                       = "gcc_mgmt_rg"
      vnet_key                     = "gcc_mgmt_vnet"
      remote_vnet_key              = "gcc_internet_vnet"
      name                         = "gcc-mgmt-inter-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    intranet_mgmt_vnet_peer = {
      rg_key                       = "gcc_intranet_rg"
      vnet_key                     = "gcc_intranet_vnet"
      remote_vnet_key              = "gcc_mgmt_vnet"
      name                         = "gcc-intra-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    mgmt_intranet_vnet_peer = {
      rg_key                       = "gcc_mgmt_rg"
      vnet_key                     = "gcc_mgmt_vnet"
      remote_vnet_key              = "gcc_intranet_vnet"
      name                         = "gcc-mgmt-intra-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }
  }
  type = any
}

# Subnets
variable "gcc_subnets" {
  default = {
    azure_internet_azfw_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      name             = "AzureFirewallSubnet"
      address_prefixes = ["10.0.0.0/24"]
    }
    gcc_internet_web_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      nsg_key          = "gcc_internet_web_nsg"
      name             = "InterWebSubnet"
      address_prefixes = ["10.0.1.0/24"]
    }
    gcc_internet_app_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      nsg_key          = "gcc_internet_app_nsg"
      name             = "InterAppSubnet"
      address_prefixes = ["10.0.2.0/24"]
    }
    gcc_internet_db_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      nsg_key          = "gcc_internet_db_nsg"
      name             = "InterDbSubnet"
      address_prefixes = ["10.0.3.0/24"]
    }
    gcc_internet_gut_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      nsg_key          = "gcc_internet_gut_nsg"
      name             = "InterGutSubnet"
      address_prefixes = ["10.0.4.0/24"]
    }
    gcc_internet_it_subnet = {
      rg_key           = "gcc_internet_rg"
      vnet_key         = "gcc_internet_vnet"
      nsg_key          = "gcc_internet_it_nsg"
      name             = "InterItSubnet"
      address_prefixes = ["10.0.5.0/24"]
    }

    # intranet
    gcc_intranet_web_subnet = {
      rg_key           = "gcc_intranet_rg"
      vnet_key         = "gcc_intranet_vnet"
      nsg_key          = "gcc_intranet_web_nsg"
      name             = "IntraWebSubnet"
      address_prefixes = ["10.1.0.0/24"]
    }
    gcc_intranet_app_subnet = {
      rg_key           = "gcc_intranet_rg"
      vnet_key         = "gcc_intranet_vnet"
      nsg_key          = "gcc_intranet_app_nsg"
      name             = "InterAppSubnet"
      address_prefixes = ["10.1.1.0/24"]
    }
    gcc_intranet_db_subnet = {
      rg_key           = "gcc_intranet_rg"
      vnet_key         = "gcc_intranet_vnet"
      nsg_key          = "gcc_intranet_db_nsg"
      name             = "InterDbSubnet"
      address_prefixes = ["10.1.2.0/24"]
    }
    gcc_intranet_gut_subnet = {
      rg_key           = "gcc_intranet_rg"
      vnet_key         = "gcc_intranet_vnet"
      nsg_key          = "gcc_intranet_gut_nsg"
      name             = "InterGutSubnet"
      address_prefixes = ["10.1.3.0/24"]
    }
    gcc_intranet_it_subnet = {
      rg_key           = "gcc_intranet_rg"
      vnet_key         = "gcc_intranet_vnet"
      nsg_key          = "gcc_intranet_it_nsg"
      name             = "InterItSubnet"
      address_prefixes = ["10.1.4.0/24"]
    }

    # mgmt
    azure_mgmt_bastion_subnet = {
      rg_key           = "gcc_mgmt_rg"
      vnet_key         = "gcc_mgmt_vnet"
      nsg_key          = "gcc_mgmt_bastion_nsg"
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.2.0.0/24"]
    }
  }
  type = any
}

# Route tables
variable "gcc_route_tables" {
  default = {
    gcc_internet_azfw_route_table = {
      rg_key                        = "gcc_internet_rg"
      rt_key                        = "gcc_internet_azfw_route_table"
      subnet_key                    = "gcc_internet_azfw_subnet"
      next_hop_resource_key         = "gcc_internet_azfw"
      name                          = "gcc-inter-azfw-route-table"
      disable_bgp_route_propagation = true
      routes = [
        {
          name                   = "Route-to-Firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_resource_type = "firewall" # next_hop_resource type is either firewall or linux_vm
        }
      ]
      tags = {}
    }
  }
  type = any
}

# Network security groups
variable "gcc_network_security_groups" {
  default = {
    gcc_internet_web_nsg = {
      rg_key = "gcc_internet_rg"
      name   = "gcc-inter-web-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }
    gcc_internet_app_nsg = {
      rg_key = "gcc_internet_rg"
      name   = "gcc-inter-app-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }
    gcc_internet_db_nsg = {
      rg_key = "gcc_internet_rg"
      name   = "gcc-inter-db-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_internet_gut_nsg = {
      rg_key = "gcc_internet_rg"
      name   = "gcc-inter-gut-nsg"
      tags   = {}
      security_rules = [
        # inbound

        {
          name                         = "AllowBastionInbound"
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = ""
          source_port_ranges           = ["22", "3389"]
          destination_port_range       = ""
          destination_port_ranges      = ["22", "3389"]
          source_address_prefix        = "10.2.0.0/24"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AllowSquidInbound"
          priority                     = 110
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "3128"
          source_port_ranges           = [""]
          destination_port_range       = "3128"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_internet_it_nsg = {
      rg_key = "gcc_internet_rg"
      name   = "gcc-inter-it-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "AllowAPIMgmtEndpoint"
          priority                     = 4000
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "3443"
          destination_port_ranges      = [""]
          source_address_prefix        = "ApiManagement"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AccessRedisServiceforCachePoliciesInbound"
          priority                     = 4001
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6381-6383"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SyncCountersforRateLimitPoliciesInbound"
          priority                     = 4002
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "4290"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureInfrastructureLoadBalancer"
          priority                     = 4003
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6390"
          destination_port_ranges      = [""]
          source_address_prefix        = "AzureLoadBalancer"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        # outbound
        {
          name                         = "AzureStorage"
          priority                     = 4004
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Storage"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureActiveDirectory"
          priority                     = 4005
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureActiveDirectory"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureSQL"
          priority                     = 4006
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "1443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "SQL"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureKeyVault"
          priority                     = 4007
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureKeyVault"
          destination_address_prefixes = [""]
        },

        {
          name                         = "LogtoEventHubPolicyandMonitoringAgent"
          priority                     = 4008
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["443", "5671", "5672"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "EventHub"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureFileShare"
          priority                     = 4009
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "445"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Storage"
          destination_address_prefixes = [""]
        },

        {
          name                         = "HealthandMonitoringExtension"
          priority                     = 4010
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["443", "12000"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureCloud"
          destination_address_prefixes = [""]
        },

        {
          name                         = "PublishDiagnosticsLogsandMetricsResourceHealthandApplication Insights"
          priority                     = 4011
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["186", "443"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureCloud"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SMTPRelay"
          priority                     = 4012
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["25", "587", "25028"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AccessRedisServiceforCachePoliciesOutbound"
          priority                     = 4013
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6381-6383"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SyncCountersforRateLimitPoliciesOutbound"
          priority                     = 4014
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "4290"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    # intranet
    gcc_intranet_web_nsg = {
      rg_key = "gcc_intranet_rg"
      name   = "gcc-intra-web-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_intranet_app_nsg = {
      rg_key = "gcc_intranet_rg"
      name   = "gcc-intra-app-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_intranet_db_nsg = {
      rg_key = "gcc_intranet_rg"
      name   = "gcc-intra-db-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },
        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_intranet_gut_nsg = {
      name   = "gcc-intra-gut-nsg"
      rg_key = "gcc_intranet_rg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "AllowBastionInbound"
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = ""
          source_port_ranges           = ["22", "3389"]
          destination_port_range       = ""
          destination_port_ranges      = ["22", "3389"]
          source_address_prefix        = "10.2.0.0/24"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AllowSquidInbound"
          priority                     = 110
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "3128"
          source_port_ranges           = [""]
          destination_port_range       = "3128"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        # outbound
        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_intranet_it_nsg = {
      rg_key = "gcc_intranet_rg"
      name   = "gcc-intra-it-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "AllowAPIMgmtEndpoint"
          priority                     = 4000
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "3443"
          destination_port_ranges      = [""]
          source_address_prefix        = "ApiManagement"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AccessRedisServiceforCachePoliciesInbound"
          priority                     = 4001
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6381-6383"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SyncCountersforRateLimitPoliciesInbound"
          priority                     = 4002
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "4290"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureInfrastructureLoadBalancer"
          priority                     = 4003
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6390"
          destination_port_ranges      = [""]
          source_address_prefix        = "AzureLoadBalancer"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        # outbound
        {
          name                         = "AzureStorage"
          priority                     = 4004
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Storage"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureActiveDirectory"
          priority                     = 4005
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureActiveDirectory"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureSQL"
          priority                     = 4006
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "1443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "SQL"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureKeyVault"
          priority                     = 4007
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureKeyVault"
          destination_address_prefixes = [""]
        },

        {
          name                         = "LogtoEventHubPolicyandMonitoringAgent"
          priority                     = 4008
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["443", "5671", "5672"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "EventHub"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AzureFileShare"
          priority                     = 4009
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "445"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Storage"
          destination_address_prefixes = [""]
        },

        {
          name                         = "HealthandMonitoringExtension"
          priority                     = 4010
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["443", "12000"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureCloud"
          destination_address_prefixes = [""]
        },

        {
          name                         = "PublishDiagnosticsLogsandMetricsResourceHealthandApplication Insights"
          priority                     = 4011
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["186", "443"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureCloud"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SMTPRelay"
          priority                     = 4012
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = ""
          destination_port_ranges      = ["25", "587", "25028"]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AccessRedisServiceforCachePoliciesOutbound"
          priority                     = 4013
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "6381-6383"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "SyncCountersforRateLimitPoliciesOutbound"
          priority                     = 4014
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "4290"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }

    gcc_mgmt_bastion_nsg = {
      rg_key = "gcc_mgmt_rg"
      name   = "gcc-mgmt-bastion-nsg"
      tags   = {}
      security_rules = [
        # inbound
        {
          name                         = "AllowBastionInbound"
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "443"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "*"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AllowGatewayManagerInbound"
          priority                     = 110
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "443"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "GatewayManager"
          source_address_prefixes      = [""]
          destination_address_prefix   = "*"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetInbound"
          priority                     = 4096
          direction                    = "Inbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "Internet"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        # outbound
        {
          name                         = "AllowRdpSshOutbound"
          priority                     = 100
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = ""
          source_port_ranges           = ["3389", "22"]
          destination_port_range       = ""
          destination_port_ranges      = ["3389", "22"]
          source_address_prefix        = "*"
          source_address_prefixes      = [""]
          destination_address_prefix   = "VirtualNetwork"
          destination_address_prefixes = [""]
        },

        {
          name                         = "AllowAzureCloudOutbound"
          priority                     = 110
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "443"
          source_port_ranges           = [""]
          destination_port_range       = "443"
          destination_port_ranges      = [""]
          source_address_prefix        = "*"
          source_address_prefixes      = [""]
          destination_address_prefix   = "AzureCloud"
          destination_address_prefixes = [""]
        },

        {
          name                         = "DenyInternetOutbound"
          priority                     = 4096
          direction                    = "Outbound"
          access                       = "Deny"
          protocol                     = "*"
          source_port_range            = "*"
          source_port_ranges           = [""]
          destination_port_range       = "*"
          destination_port_ranges      = [""]
          source_address_prefix        = "VirtualNetwork"
          source_address_prefixes      = [""]
          destination_address_prefix   = "Internet"
          destination_address_prefixes = [""]
        }
      ]
    }
  }
  type = any
}

# Network security group associations
variable "gcc_network_security_group_associations" {
  default = {
    # internet
    gcc_internet_web_subnet_nsg_assoc = {
      nsg_key    = "gcc_internet_web_nsg"
      subnet_key = "gcc_internet_web_subnet"
    }
    gcc_internet_app_subnet_nsg_assoc = {
      nsg_key    = "gcc_internet_app_nsg"
      subnet_key = "gcc_internet_app_subnet"
    }
    gcc_internet_db_subnet_nsg_assoc = {
      nsg_key    = "gcc_internet_db_nsg"
      subnet_key = "gcc_internet_db_subnet"
    }
    gcc_internet_gut_subnet_nsg_assoc = {
      nsg_key    = "gcc_internet_gut_nsg"
      subnet_key = "gcc_internet_gut_subnet"
    }
    gcc_internet_it_subnet_nsg_assoc = {
      nsg_key    = "gcc_internet_it_nsg"
      subnet_key = "gcc_internet_it_subnet"
    }
    # intranet
    gcc_intranet_web_subnet_nsg_assoc = {
      nsg_key    = "gcc_intranet_web_nsg"
      subnet_key = "gcc_intranet_web_subnet"
    }
    gcc_intranet_app_subnet_nsg_assoc = {
      nsg_key    = "gcc_intranet_app_nsg"
      subnet_key = "gcc_intranet_app_subnet"
    }
    gcc_intranet_db_subnet_nsg_assoc = {
      nsg_key    = "gcc_intranet_db_nsg"
      subnet_key = "gcc_intranet_db_subnet"
    }
    gcc_intranet_gut_subnet_nsg_assoc = {
      nsg_key    = "gcc_intranet_gut_nsg"
      subnet_key = "gcc_intranet_gut_subnet"
    }
    gcc_intranet_it_subnet_nsg_assoc = {
      nsg_key    = "gcc_intranet_it_nsg"
      subnet_key = "gcc_intranet_it_subnet"
    }
    # mgmt
    gcc_mgmt_bastion_subnet_nsg_assoc = {
      nsg_key    = "gcc_mgmt_bastion_nsg"
      subnet_key = "gcc_mgmt_bastion_subnet"
    }
  }
  type = any
}

# Bastion
variable "gcc_bastions" {
  default = {
    gcc_mgmt_bastion = {
      rg_key         = "gcc_mgmt_rg"
      subnet_key     = "azure_mgmt_bastion_subnet"
      public_ip_key  = "azure_bastion_public_ip"
      name           = "gcc-mgmt-bastion"
      ip_config_name = "gcc-mgmt-bastiion-ip-config"
    }
  }
  type = any
}

# Firewall
variable "gcc_firewalls" {
  default = {
    gcc_internet_azfw = {
      rg_key         = "gcc_internet_rg"
      subnet_key     = "azure_internet_azfw_subnet"
      public_ip_key  = "azure_internet_azfw_public_ip"
      name           = "gcc-inter-azfw"
      ip_config_name = "gcc-inter-azfw-ip-config"
      sku_name       = "AZFW_VNet"
      sku_tier       = "Standard"
    }
  }
  type = any
}

# Public ips
variable "gcc_public_ips" {
  default = {
    azure_internet_azfw_public_ip = {
      rg_key            = "gcc_internet_rg"
      name              = "gcc-inter-azfw-ip"
      allocation_method = "Static"
      sku               = "Standard"
    }

    azure_mgmt_bastion_public_ip = {
      rg_key            = "gcc_mgmt_rg"
      name              = "gcc-mgmt-bastion-ip"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }
  type = any
}

# Virtual machines
variable "gcc_linux_vm_nics" {
  default = {
    gcc_internet_gut_proxy_vm_nic = {
      rg_key         = "gcc_internet_rg"
      subnet_key     = "gcc_internet_gut_subnet"
      name           = "gcc-inter-gut-proxy-nic"
      ip_config_name = "gcc-inter-gut-proxy-ip-config"

    }
    gcc_intranet_gut_proxy_vm_nic = {
      rg_key         = "gcc_intranet_rg"
      subnet_key     = "gcc_intranet_gut_subnet"
      name           = "gcc-intra-gut-proxy-nic"
      ip_config_name = "gcc-intra-gut-proxy-ip-config"
    }
  }
  type = any
}
variable "gcc_linux_vms" {
  default = {
    gcc_internet_gut_proxy_vm = {
      rg_key                          = "gcc_internet_rg"
      nic_key                         = "gcc_internet_gut_proxy_vm_nic"
      name                            = "gcc-inter-gut-proxy"
      size                            = "Standard_B1ms"
      disable_password_authentication = false
      admin_username                  = "adminuser"
      admin_password                  = "P@55w0rd1234"
      caching                         = "ReadWrite"
      storage_account_type            = "Standard_LRS"
    }

    gcc_intranet_gut_proxy_vm = {
      rg_key                          = "gcc_intranet_rg"
      nic_key                         = "gcc_intranet_gut_proxy_vm_nic"
      name                            = "gcc-intra-gut-proxy"
      size                            = "Standard_B1ms"
      disable_password_authentication = false
      admin_username                  = "adminuser"
      admin_password                  = "P@55w0rd1234"
      caching                         = "ReadWrite"
      storage_account_type            = "Standard_LRS"
    }
  }
  type = any
}

variable "gcc_linux_vm_extensions" {
  default = {
    gcc_internet_gut_proxy_vm_extension = {
      linux_vm_key     = "gcc_internet_gut_proxy_vm"
      name             = "gcc-inter-gut-proxy-vm-ext"
      extension_script = "../scripts/squid_setup/squid_setup.sh"
    }
    gcc_intranet_gut_proxy_vm_extension = {
      linux_vm_key     = "gcc_intranet_gut_proxy_vm"
      name             = "gcc-intra-gut-proxy-vm-ext"
      extension_script = "../scripts/squid_setup/squid_setup.sh"
    }
  }
}

# API management
variable "gcc_apims" {
  default = {
    gcc_internet_it_apim = {
      rg_key          = "gcc_internet_rg"
      subnet_key      = "gcc_internet_it_subnet"
      name            = "gcc-internet-it-apim"
      publisher_name  = "your-name"
      publisher_email = "your-email"
      sku_name        = "Developer"
      sku_capacity    = "1"
      type            = "Internal"
    }

    gcc_intranet_it_apim = {
      rg_key          = "gcc_intranet_rg"
      subnet_key      = "gcc_intranet_it_subnet"
      name            = "gcc-intranet-it-apim"
      publisher_name  = "your-name"
      publisher_email = "your-email"
      sku_name        = "Developer"
      sku_capacity    = "1"
      type            = "Internal"
    }
  }
  type = any
}

# Private dns zones
variable "gcc_private_dns_zones" {
  default = {
    azure_api_net = {
      rg_key = "gcc_mgmt_rg"
      name   = "azure-api.net"
    }
  }
  type = any
}
variable "gcc_private_dns_zone_apim_a_records" {
  default = {
    gcc_internet_it_apim_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = ""
      ttl                  = 300
    }

    gcc_internet_it_apim_portal_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "portal"
      ttl                  = 300
    }

    gcc_internet_it_apim_developer_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "developer"
      ttl                  = 300
    }

    gcc_internet_it_apim_management_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "management"
      ttl                  = 300
    }

    gcc_internet_it_apim_scm_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "scm"
      ttl                  = 300
    }

    gcc_intranet_it_apim_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = ""
      ttl                  = 300
    }

    gcc_intranet_it_apim_portal_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "portal"
      ttl                  = 300
    }

    gcc_intranet_it_apim_developer_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "developer"
      ttl                  = 300
    }

    gcc_intranet_it_apim_management_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "management"
      ttl                  = 300
    }

    gcc_intranet_it_apim_scm_a_record = {
      rg_key               = "gcc_mgmt_rg"
      apim_key             = "gcc_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "scm"
      ttl                  = 300
    }
  }
  type = any
}

# AKS
variable "gcc_aks_clusters" {
  default = {
    gcc_internet_app_aks_private_cluster = {
      rg_key                            = "gcc_internet_rg"
      subnet_key                        = "gcc_internet_app_aks_subnet"
      name                              = "gcc-inter-app-aks-pte-cls"
      dns_prefix                        = "aks-private"
      private_cluster_enabled           = true
      default_node_pool_name            = "default"
      default_node_pool_node_count      = "1"
      default_node_pool_vm_size         = "Standard_D2_v2"
      network_profile_network_plugin    = "azure"
      network_profile_outbound_type     = "userDefinedRouting"
      network_profile_load_balancer_sku = "standard"
      identity_type                     = "SystemAssigned"
    }
  }
}

variable "gcc_aks_cluster_private_dns_zone_vnet_links" {
  default = {
    gcc_internet_app_aks_private_cluster_dns_zone_vnet_link = {
      rg_key                    = "gcc_mgmt_rg"
      vnet_key                  = "gcc_mgmt_vnet"
      aks_cluster_key           = "gcc_internet_app_aks_private_cluster"
      name                      = "gcc-mgmt-inter-app-aks-pte-cls-dns-zone-vnet-link"
      aks_cluster_location_name = "eastus"
    }
  }
}