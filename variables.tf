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
variable "aias_resource_groups" {
  default = {
    aias_internet_rg = {
      name = "aias-inter-rg"
    }

    aias_intranet_rg = {
      name = "aias-intra-rg"
    }

    aias_mgmt_rg = {
      name = "aias-mgmt-rg"
    }
  }
}

# Virtual networks
variable "aias_virtual_networks" {
  default = {
    aias_internet_vnet = {
      rg_key        = "aias_internet_rg"
      name          = "aias-inter-vnet"
      address_space = ["10.0.0.0/16"]
      tags          = {}
    }

    aias_intranet_vnet = {
      rg_key        = "aias_intranet_rg"
      name          = "aias-intra-vnet"
      address_space = ["10.1.0.0/16"]
      tags          = {}
    }

    aias_mgmt_vnet = {
      rg_key        = "aias_mgmt_rg"
      name          = "aias-mgmt-vnet"
      address_space = ["10.2.0.0/16"]
      tags          = {}
    }
  }
}

# Virtual network peerings
variable "aias_vnet_peers" {
  default = {
    internet_intranet_vnet_peer = {
      rg_key                       = "aias_internet_rg"
      vnet_key                     = "aias_internet_vnet"
      remote_vnet_key              = "aias_intranet_vnet"
      name                         = "aias-inter-intra-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    internet_mgmt_vnet_peer = {
      rg_key                       = "aias_internet_rg"
      vnet_key                     = "aias_internet_vnet"
      remote_vnet_key              = "aias_mgmt_vnet"
      name                         = "aias-inter-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }

    intranet_mgmt_vnet_peer = {
      rg_key                       = "aias_intranet_rg"
      vnet_key                     = "aias_intranet_vnet"
      remote_vnet_key              = "aias_mgmt_vnet"
      name                         = "aias-intra-mgmt-peering"
      allow_virtual_network_access = "true"
      allow_forwarded_traffic      = "true"
      allow_gateway_transit        = "false"
      use_remote_gateways          = "false"
    }
  }
  type = any
}

# Subnets
variable "aias_subnets" {
  default = {
    azure_internet_azfw_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      name             = "AzureFirewallSubnet"
      address_prefixes = ["10.0.0.0/24"]
    }
    aias_internet_web_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      nsg_key          = "aias_internet_web_nsg"
      name             = "InterWebSubnet"
      address_prefixes = ["10.0.1.0/24"]
    }
    aias_internet_app_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      nsg_key          = "aias_internet_app_nsg"
      name             = "InterAppSubnet"
      address_prefixes = ["10.0.2.0/24"]
      # delegation = [
      #   {
      #     name = "asev3_service_delegation"
      #     service_delegation = [
      #       {
      #         name    = "Microsoft.Web/hostingEnvironments"                  # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
      #         actions = ["Microsoft.Network/virtualNetworks/subnets/action"] # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
      #       },
      #     ]
      #   },
      # ]
    }
    aias_internet_db_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      nsg_key          = "aias_internet_db_nsg"
      name             = "InterDbSubnet"
      address_prefixes = ["10.0.3.0/24"]
    }
    aias_internet_gut_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      nsg_key          = "aias_internet_gut_nsg"
      name             = "InterGutSubnet"
      address_prefixes = ["10.0.4.0/24"]
    }
    aias_internet_it_subnet = {
      rg_key           = "aias_internet_rg"
      vnet_key         = "aias_internet_vnet"
      nsg_key          = "aias_internet_it_nsg"
      name             = "InterItSubnet"
      address_prefixes = ["10.0.5.0/24"]
    }

    # intranet
    aias_intranet_web_subnet = {
      rg_key           = "aias_intranet_rg"
      vnet_key         = "aias_intranet_vnet"
      nsg_key          = "aias_intranet_web_nsg"
      name             = "IntraWebSubnet"
      address_prefixes = ["10.1.0.0/24"]
    }
    aias_intranet_app_subnet = {
      rg_key           = "aias_intranet_rg"
      vnet_key         = "aias_intranet_vnet"
      nsg_key          = "aias_intranet_app_nsg"
      name             = "InterAppSubnet"
      address_prefixes = ["10.1.1.0/24"]
    }
    aias_intranet_db_subnet = {
      rg_key           = "aias_intranet_rg"
      vnet_key         = "aias_intranet_vnet"
      nsg_key          = "aias_intranet_db_nsg"
      name             = "InterDbSubnet"
      address_prefixes = ["10.1.2.0/24"]
    }
    aias_intranet_gut_subnet = {
      rg_key           = "aias_intranet_rg"
      vnet_key         = "aias_intranet_vnet"
      nsg_key          = "aias_intranet_gut_nsg"
      name             = "InterGutSubnet"
      address_prefixes = ["10.1.3.0/24"]
    }
    aias_intranet_it_subnet = {
      rg_key           = "aias_intranet_rg"
      vnet_key         = "aias_intranet_vnet"
      nsg_key          = "aias_intranet_it_nsg"
      name             = "InterItSubnet"
      address_prefixes = ["10.1.4.0/24"]
    }

    # mgmt
    azure_mgmt_bastion_subnet = {
      rg_key           = "aias_mgmt_rg"
      vnet_key         = "aias_mgmt_vnet"
      nsg_key          = "aias_mgmt_bastion_nsg"
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.2.0.0/24"]
    }
  }
  type = any
}

# Route tables
variable "aias_route_tables" {
  default = {
    aias_internet_azfw_route_table = {
      rg_key                        = "aias_internet_rg"
      rt_key                        = "aias_internet_azfw_route_table"
      subnet_key                    = "aias_internet_azfw_subnet"
      next_hop_resource_key         = "aias_internet_azfw"
      name                          = "aias-inter-azfw-route-table"
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
variable "aias_network_security_groups" {
  default = {
    aias_internet_web_nsg = {
      rg_key = "aias_internet_rg"
      name   = "aias-inter-web-nsg"
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
    aias_internet_app_nsg = {
      rg_key = "aias_internet_rg"
      name   = "aias-inter-app-nsg"
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
    aias_internet_db_nsg = {
      rg_key = "aias_internet_rg"
      name   = "aias-inter-db-nsg"
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

    aias_internet_gut_nsg = {
      rg_key = "aias_internet_rg"
      name   = "aias-inter-gut-nsg"
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

    aias_internet_it_nsg = {
      rg_key = "aias_internet_rg"
      name   = "aias-inter-it-nsg"
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
    aias_intranet_web_nsg = {
      rg_key = "aias_intranet_rg"
      name   = "aias-intra-web-nsg"
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

    aias_intranet_app_nsg = {
      rg_key = "aias_intranet_rg"
      name   = "aias-intra-app-nsg"
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

    aias_intranet_db_nsg = {
      rg_key = "aias_intranet_rg"
      name   = "aias-intra-db-nsg"
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

    aias_intranet_gut_nsg = {
      name   = "aias-intra-gut-nsg"
      rg_key = "aias_intranet_rg"
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

    aias_intranet_it_nsg = {
      rg_key = "aias_intranet_rg"
      name   = "aias-intra-it-nsg"
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

    aias_mgmt_bastion_nsg = {
      rg_key = "aias_mgmt_rg"
      name   = "aias-mgmt-bastion-nsg"
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
variable "aias_network_security_group_associations" {
  default = {
    # internet
    aias_internet_web_subnet_nsg_assoc = {
      nsg_key    = "aias_internet_web_nsg"
      subnet_key = "aias_internet_web_subnet"
    }
    aias_internet_app_subnet_nsg_assoc = {
      nsg_key    = "aias_internet_app_nsg"
      subnet_key = "aias_internet_app_subnet"
    }
    aias_internet_db_subnet_nsg_assoc = {
      nsg_key    = "aias_internet_db_nsg"
      subnet_key = "aias_internet_db_subnet"
    }
    aias_internet_gut_subnet_nsg_assoc = {
      nsg_key    = "aias_internet_gut_nsg"
      subnet_key = "aias_internet_gut_subnet"
    }
    aias_internet_it_subnet_nsg_assoc = {
      nsg_key    = "aias_internet_it_nsg"
      subnet_key = "aias_internet_it_subnet"
    }
    # intranet
    aias_intranet_web_subnet_nsg_assoc = {
      nsg_key    = "aias_intranet_web_nsg"
      subnet_key = "aias_intranet_web_subnet"
    }
    aias_intranet_app_subnet_nsg_assoc = {
      nsg_key    = "aias_intranet_app_nsg"
      subnet_key = "aias_intranet_app_subnet"
    }
    aias_intranet_db_subnet_nsg_assoc = {
      nsg_key    = "aias_intranet_db_nsg"
      subnet_key = "aias_intranet_db_subnet"
    }
    aias_intranet_gut_subnet_nsg_assoc = {
      nsg_key    = "aias_intranet_gut_nsg"
      subnet_key = "aias_intranet_gut_subnet"
    }
    aias_intranet_it_subnet_nsg_assoc = {
      nsg_key    = "aias_intranet_it_nsg"
      subnet_key = "aias_intranet_it_subnet"
    }
    # mgmt
    aias_mgmt_bastion_subnet_nsg_assoc = {
      nsg_key    = "aias_mgmt_bastion_nsg"
      subnet_key = "aias_mgmt_bastion_subnet"
    }
  }
  type = any
}

# Bastion
variable "aias_bastions" {
  default = {
    aias_mgmt_bastion = {
      rg_key         = "aias_mgmt_rg"
      subnet_key     = "azure_mgmt_bastion_subnet"
      public_ip_key  = "azure_bastion_public_ip"
      name           = "aias-mgmt-bastion"
      ip_config_name = "aias-mgmt-bastiion-ip-config"
    }
  }
  type = any
}

# Firewall
variable "aias_firewalls" {
  default = {
    aias_internet_azfw = {
      rg_key         = "aias_internet_rg"
      subnet_key     = "azure_internet_azfw_subnet"
      public_ip_key  = "azure_internet_azfw_public_ip"
      name           = "aias-inter-azfw"
      ip_config_name = "aias-inter-azfw-ip-config"
      sku_name       = "AZFW_VNet"
      sku_tier       = "Standard"
    }
  }
  type = any
}

# Public ips
variable "aias_public_ips" {
  default = {
    azure_internet_azfw_public_ip = {
      rg_key            = "aias_internet_rg"
      name              = "aias-inter-azfw-ip"
      allocation_method = "Static"
      sku               = "Standard"
    }

    azure_mgmt_bastion_public_ip = {
      rg_key            = "aias_mgmt_rg"
      name              = "aias-mgmt-bastion-ip"
      allocation_method = "Static"
      sku               = "Standard"
    }
  }
  type = any
}

# Virtual machines
variable "aias_linux_vm_nics" {
  default = {
    aias_internet_gut_proxy_vm_nic = {
      rg_key         = "aias_internet_rg"
      subnet_key     = "aias_internet_gut_subnet"
      name           = "aias-inter-gut-proxy-nic"
      ip_config_name = "aias-inter-gut-proxy-ip-config"

    }
    aias_intranet_gut_proxy_vm_nic = {
      rg_key         = "aias_intranet_rg"
      subnet_key     = "aias_intranet_gut_subnet"
      name           = "aias-intra-gut-proxy-nic"
      ip_config_name = "aias-intra-gut-proxy-ip-config"
    }
  }
  type = any
}
variable "aias_linux_vms" {
  default = {
    aias_internet_gut_proxy_vm = {
      rg_key                          = "aias_internet_rg"
      nic_key                         = "aias_internet_gut_proxy_vm_nic"
      name                            = "aias-inter-gut-proxy"
      size                            = "Standard_B1ms"
      disable_password_authentication = false
      admin_username                  = "adminuser"
      admin_password                  = "P@55w0rd1234"
      caching                         = "ReadWrite"
      storage_account_type            = "Standard_LRS"
    }

    aias_intranet_gut_proxy_vm = {
      rg_key                          = "aias_intranet_rg"
      nic_key                         = "aias_intranet_gut_proxy_vm_nic"
      name                            = "aias-intra-gut-proxy"
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

# API management
variable "aias_apims" {
  default = {
    aias_internet_it_apim = {
      rg_key          = "aias_internet_rg"
      subnet_key      = "aias_internet_it_subnet"
      name            = "aias-internet-it-apim"
      publisher_name  = "your-name"
      publisher_email = "your-email"
      sku_name        = "Developer"
      sku_capacity    = "1"
      type            = "Internal"
    }

    aias_intranet_it_apim = {
      rg_key          = "aias_intranet_rg"
      subnet_key      = "aias_intranet_it_subnet"
      name            = "aias-intranet-it-apim"
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
variable "aias_private_dns_zones" {
  default = {
    azure_api_net = {
      rg_key = "aias_mgmt_rg"
      name   = "azure-api.net"
    }
  }
  type = any
}
variable "aias_private_dns_zone_apim_a_records" {
  default = {
    aias_internet_it_apim_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = ""
      ttl                  = 300
    }

    aias_internet_it_apim_portal_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "portal"
      ttl                  = 300
    }

    aias_internet_it_apim_developer_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "developer"
      ttl                  = 300
    }

    aias_internet_it_apim_management_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "management"
      ttl                  = 300
    }

    aias_internet_it_apim_scm_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_internet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "scm"
      ttl                  = 300
    }

    aias_intranet_it_apim_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = ""
      ttl                  = 300
    }

    aias_intranet_it_apim_portal_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "portal"
      ttl                  = 300
    }

    aias_intranet_it_apim_developer_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "developer"
      ttl                  = 300
    }

    aias_intranet_it_apim_management_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "management"
      ttl                  = 300
    }

    aias_intranet_it_apim_scm_a_record = {
      rg_key               = "aias_mgmt_rg"
      apim_key             = "aias_intranet_it_apim"
      private_dns_zone_key = "azure_api_net"
      endpoint_name        = "scm"
      ttl                  = 300
    }
  }
  type = any
}