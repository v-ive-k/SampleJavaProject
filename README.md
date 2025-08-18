# Shared Networking resources
resource "azurerm_virtual_network" "net_vnet" {
    name = var.net_vnet_name
    location = azurerm_resource_group.net_rg.location
    resource_group_name = azurerm_resource_group.net_rg.name
    address_space = var.net_vnet_prefix
    tags = var.global_tags
    ddos_protection_plan {
      id = data.azurerm_network_ddos_protection_plan.ont-prod1-ddos.id
      enable = true
    }
}

# Route tables
resource "azurerm_route_table" "appgw_snet_route_table" {
    name = var.net_appgw_snet_rt_name
    location = azurerm_resource_group.net_rg.location
    resource_group_name = azurerm_resource_group.net_rg.name
    tags = var.global_tags
    route {
        name = "AZFirewallInternal"
        address_prefix = azurerm_subnet.node_pool_01.address_prefixes[0]
        next_hop_type = "VirtualAppliance"
        next_hop_in_ip_address = azurerm_firewall.net_afw.ip_configuration[0].private_ip_address
    }
}

resource "azurerm_route_table" "aks_pool01_snet_route_table" {
    name = var.aks_node_pool01_snet_rt_name
    location = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    tags = var.global_tags
    route {
        name = "AppGW"
        address_prefix = azurerm_subnet.net_appgw_subnet.address_prefixes[0]
        next_hop_type = "VirtualAppliance"
        # Check in QA but this used to be set to what the internal IP address of the firewall would be with a single IP configuration.
        next_hop_in_ip_address = azurerm_firewall.net_afw.ip_configuration[0].private_ip_address
    }
    route {
        name = "Default"
        address_prefix = "0.0.0.0/0"
        next_hop_type = "VirtualAppliance"
        # Check in QA but this used to be set to what the internal IP address of the firewall would be with a single IP configuration.
        next_hop_in_ip_address = azurerm_firewall.net_afw.ip_configuration[0].private_ip_address
    }
}

resource "azurerm_subnet" "net_gateway_snet" {
    name = var.net_gateway_snet_name
    resource_group_name = azurerm_resource_group.net_rg.name
    virtual_network_name = azurerm_virtual_network.net_vnet.name
    address_prefixes = [var.net_gateway_snet_prefix]
}

resource "azurerm_subnet" "net_appgw_subnet" {
    name = var.net_appgw_snet_name
    resource_group_name = azurerm_resource_group.net_rg.name
    virtual_network_name = azurerm_virtual_network.net_vnet.name
    address_prefixes = [var.net_appgw_snet_prefix]
}

resource "azurerm_subnet_route_table_association" "appgw_subnet_rt_association" {
    subnet_id = azurerm_subnet.net_appgw_subnet.id
    route_table_id = azurerm_route_table.appgw_snet_route_table.id
}

resource "azurerm_subnet" "net_firewall_snet" {
    name = var.net_firewall_snet_name
    resource_group_name = azurerm_resource_group.net_rg.name
    virtual_network_name = azurerm_virtual_network.net_vnet.name
    address_prefixes = [var.net_firewall_snet_prefix]
}

resource "azurerm_subnet" "net_firewall_mgmt_snet" {
    name = var.net_firewall_mgmt_snet_Name
    resource_group_name = azurerm_resource_group.net_rg.name
    virtual_network_name = azurerm_virtual_network.net_vnet.name
    address_prefixes = [var.net_firewall_mgmt_snet_prefix]
}

resource "azurerm_network_security_group" "appgw_nsg" {
    location            = azurerm_resource_group.net_rg.location
    name                = var.net_appgw_snet_nsg_name
    resource_group_name = azurerm_resource_group.net_rg.name
    tags                = var.global_tags
}

resource "azurerm_network_security_rule" "appgw_nsg_ports" {
    access                                     = "Allow"
    description                                = null
    destination_address_prefix                 = "*"
    destination_port_range                     = "65200-65535"
    direction                                  = "Inbound"
    name                                       = "AllowTagCustom65200-65535Inbound"
    priority                                   = 100
    protocol                                   = "*"
    source_address_prefix                      = "GatewayManager"
    source_port_range                          = "*"
    resource_group_name = azurerm_resource_group.net_rg.name
    network_security_group_name = azurerm_network_security_group.appgw_nsg.name
}

resource "azurerm_network_security_rule" "appgw_nsg_http" {
    access                                     = "Allow"
    description                                = null
    destination_address_prefix                 = "*"
    destination_port_range                     = "80"
    direction                                  = "Inbound"
    name                                       = "AllowAnyHTTPInbound"
    priority                                   = 110
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_port_range                          = "*"
    resource_group_name = azurerm_resource_group.net_rg.name
    network_security_group_name = azurerm_network_security_group.appgw_nsg.name
}

resource "azurerm_network_security_rule" "appgw_nsg_https" {
    access                                     = "Allow"
    description                                = null
    destination_address_prefix                 = "*"
    destination_port_range                     = "443"
    direction                                  = "Inbound"
    name                                       = "AllowAnyHTTPsInbound"
    priority                                   = 120
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_port_range                          = "*"
    resource_group_name = azurerm_resource_group.net_rg.name
    network_security_group_name = azurerm_network_security_group.appgw_nsg.name
}


# AKS Networking
resource "azurerm_virtual_network" "aks_vnet" {
    name = var.aks_vnet_name
    location = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    address_space = var.aks_vnet_prefix
    tags = var.global_tags
}

# Permission needed to allow AKS to create IP address for load balancer
resource "azurerm_role_assignment" "aks_vnet_net_contributor" {
  scope = azurerm_virtual_network.aks_vnet.id
  role_definition_name = "Network Contributor"
  principal_id = var.aks_rg_contributor
}

resource "azurerm_subnet" "node_pool_01" {
    name = var.aks_node_pool01_snet_name
    resource_group_name = azurerm_resource_group.aks_rg.name
    virtual_network_name = azurerm_virtual_network.aks_vnet.name
    address_prefixes = [var.aks_node_pool01_snet_prefix]
}

resource "azurerm_network_security_group" "aks_pool01_nsg" {
    name = "AKS-nsg" # change this
    location = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    tags = var.global_tags
}

resource "azurerm_network_security_rule" "aks_pool01_nsg_http" {
    access                                     = "Allow"
    description                                = null
    destination_address_prefix                 = "*"
    destination_port_range                     = "80"
    direction                                  = "Inbound"
    name                                       = "AllowAnyHTTPInbound"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_port_range                          = "*"
    resource_group_name = azurerm_resource_group.aks_rg.name
    network_security_group_name = azurerm_network_security_group.aks_pool01_nsg.name
}

resource "azurerm_network_security_rule" "aks_pool01_nsg_https" {
    access                                     = "Allow"
    description                                = null
    destination_address_prefix                 = "*"
    destination_port_range                     = "443"
    direction                                  = "Inbound"
    name                                       = "AllowAnyHTTPsInbound"
    priority                                   = 110
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_port_range                          = "*"
    resource_group_name = azurerm_resource_group.aks_rg.name
    network_security_group_name = azurerm_network_security_group.aks_pool01_nsg.name
}

resource "azurerm_subnet_route_table_association" "aks_pool01_subnet_rt_association" {
    subnet_id = azurerm_subnet.node_pool_01.id
    route_table_id = azurerm_route_table.aks_pool01_snet_route_table.id
}

# Peering
resource "azurerm_virtual_network_peering" "net_vnet_aks_vnet" {
  name = "${azurerm_virtual_network.net_vnet.name}_TO_${azurerm_virtual_network.aks_vnet.name}"
  resource_group_name = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.net_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.aks_vnet.id
  allow_forwarded_traffic = "true"
}

resource "azurerm_virtual_network_peering" "aks_vnet_net_vnet" {
  name = "${azurerm_virtual_network.aks_vnet.name}_TO_${azurerm_virtual_network.net_vnet.name}"
  resource_group_name = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.net_vnet.id
  allow_forwarded_traffic = "true"
  depends_on = [ azurerm_virtual_network_peering.net_vnet_aks_vnet ]
}

# Public IP Address
resource "azurerm_public_ip" "cs_dev01_agw_pip01" {
    name = var.net_appgw_pip01_name
    resource_group_name = azurerm_resource_group.net_rg.name
    location = azurerm_resource_group.net_rg.location
    allocation_method = "Static"
    zones = [ "1", "2", "3" ]
}

resource "azurerm_public_ip" "net_afw_pip00" {
    name = var.net_afw_pip00_name
    resource_group_name = azurerm_resource_group.net_rg.name
    location = azurerm_resource_group.net_rg.location
    allocation_method = "Static"
    zones = [ "1", "2", "3" ]
}

# Firewall
resource "azurerm_firewall_policy" "net_afw_policy01" {
  name = var.net_afw_policy01_name
  resource_group_name = azurerm_resource_group.net_rg.name
  location = azurerm_resource_group.net_rg.location
  sku = "Premium"
  threat_intelligence_mode = "Deny"
  tags = var.global_tags
  intrusion_detection {
    mode = "Deny"
  }
  dns {
    proxy_enabled = "true"
    servers = []
  }
}

resource "azurerm_firewall" "net_afw" {
  name = var.net_afw_name
  resource_group_name = azurerm_resource_group.net_rg.name
  location = azurerm_resource_group.net_rg.location
  sku_name = "AZFW_VNet"
  sku_tier = "Premium"
  threat_intel_mode = "Alert"
  firewall_policy_id = azurerm_firewall_policy.net_afw_policy01.id
  zones = []
  tags = var.global_tags

  ip_configuration {
    name = azurerm_public_ip.net_afw_pip00.name
    subnet_id = azurerm_subnet.net_firewall_snet.id
    public_ip_address_id = azurerm_public_ip.net_afw_pip00.id
  }
}

# Firewall logging
resource "azurerm_monitor_diagnostic_setting" "afw_diag" {
    name = var.net_afw_diagnostic_name
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_law.id
    target_resource_id = azurerm_firewall.net_afw.id
    log_analytics_destination_type = "Dedicated"

    enabled_log {
        category = "AZFWApplicationRule"
    }

    enabled_log {
        category = "AZFWApplicationRuleAggregation"
    }

    enabled_log {
        category = "AZFWDnsQuery"
    }

    enabled_log {
        category = "AZFWFatFlow"
    }

    enabled_log {
        category = "AZFWFlowTrace"
    }

    enabled_log {
        category = "AZFWFqdnResolveFailure"
    }

    enabled_log {
        category = "AZFWIdpsSignature"
    }

    enabled_log {
        category = "AZFWNatRule"
    }

    enabled_log {
        category = "AZFWNatRuleAggregation"
    }

    enabled_log {
        category = "AZFWNetworkRule"
    }

    enabled_log {
        category = "AZFWNetworkRuleAggregation"
    }

    enabled_log {
        category = "AZFWThreatIntel"
    }

    metric {
      category = "AllMetrics"
      enabled = false
    }
} 

# Firewall rules
resource "azurerm_firewall_policy_rule_collection_group" "net_afw_rule_collection01" {
  name = var.net_afw_rule_collection_Group01_name
  firewall_policy_id = azurerm_firewall_policy.net_afw_policy01.id
  priority = 100
  network_rule_collection {
    name = var.net_afw_rule_collection01_name
    priority = 100
    action = "Allow"
    rule {
        name = "HTTP_In"
        source_addresses = [ azurerm_subnet.net_appgw_subnet.address_prefixes[0] ]
        destination_ports = [ "80" ]
        protocols = [ "TCP", ]
        destination_addresses = [ azurerm_subnet.node_pool_01.address_prefixes[0] ]
    }
    rule {
        name = "HTTPS_In"
        source_addresses = [ azurerm_subnet.net_appgw_subnet.address_prefixes[0] ]
        destination_ports = [ "443" ]
        protocols = [ "TCP", ]
        destination_addresses = [ azurerm_subnet.node_pool_01.address_prefixes[0] ]
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "net_afw_rule_collection02" {
    name               = var.net_afw_rule_collection_Group02_name
    firewall_policy_id = azurerm_firewall_policy.net_afw_policy01.id
    priority           = 110

    network_rule_collection {
        name     = var.net_afw_rule_collection02_name
        action   = "Allow"
        priority = 110

        rule {
            description           = null
            destination_addresses = [ "AzureCloud.southcentralus", ]
            destination_ports     = [ "1194", ]
            name                  = "apiudp"
            protocols             = [ "UDP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_addresses = [ "AzureCloud.southcentralus", ]
            destination_ports     = [ "9000", ]
            name                  = "apitcp"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "ntp.ubuntu.com", ]
            destination_ports     = [ "123", ]
            name                  = "time"
            protocols             = [ "UDP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "mcr.microsoft.com", ]
            destination_ports     = [ "443", ]
            name                  = "mcr"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [
                "data.mcr.microsoft.com",
                "mcr-0001.mcr-msedge.net",
            ]
            destination_ports     = [ "443", ]
            name                  = "mcr_storage"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "management.azure.com", ]
            destination_ports     = [ "443", ]
            name                  = "aks_mgmt"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "login.microsoftonline.com", ]
            destination_ports     = [ "443", ]
            name                  = "entra_auth"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "packages.microsoft.com", ]
            destination_ports     = [ "443", ]
            name                  = "packages_ms"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "acs-mirror.azureedge.net", ]
            destination_ports     = [ "443", ]
            name                  = "packages_acs"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description           = null
            destination_fqdns     = [ "packages.aks.azure.com", ]
            destination_ports     = [ "443", ]
            name                  = "packages_aks"
            protocols             = [ "TCP", ]
            source_addresses      = [ "*", ]
        }
        rule {
            description = null
            destination_fqdns = [
                "ghcr.io",
                "pkg-containers.githubusercontent.com",
            ]
            destination_ports = [ "443", ]
            name = "ghcr"
            protocols = [ "TCP", ]
            source_addresses = [ "*", ]
        }
        rule {
            description = null
            destination_fqdns = [
                "docker.io",
                "registry-1.docker.io",
                "production.cloudflare.docker.com",
                "ubuntu.com",
            ]
            destination_ports = [ "443", ]
            name = "docker"
            protocols = [ "TCP", ]
            source_addresses = [ "*", ]
        }
        rule {
            destination_addresses = [ "*", ]
            name = "FQDN-cs-dev1-net-aks-pool1_out"
            destination_ports = [
                "80",
                "443",
            ]
            protocols = [ "TCP", ]
            source_addresses = [ "10.208.0.0/16"]
        }
        # Saving for if we can find the domains needed to allow configuration of AKS
        # rule {
        #     destination_fqdns = [
        #         "k8s.io",
        #         "pkg.dev",
        #         "amazonaws.com",
        #         "ubuntu.com",                
        #     ]
        #     name = "FQDN-cs-dev1-net-aks-pool1_out"
        #     destination_ports = [
        #         "80",
        #         "443",
        #     ]
        #     protocols = [ "TCP", ]
        #     source_addresses = ["*", ]
        # }
    }
}

resource "azurerm_firewall_policy_rule_collection_group" "net_afw_rule_collection03" {
    name               = var.net_afw_rule_collection_Group03_name
    firewall_policy_id = azurerm_firewall_policy.net_afw_policy01.id
    priority           = 300

    application_rule_collection {
        action   = "Allow"
        name     = var.net_afw_rule_collection03_name
        priority = 300

        rule {
            description           = null
            destination_fqdn_tags = [ "AzureKubernetesService", ]
            name                  = "aksfwar"
            source_addresses      = [ "*", ]
            terminate_tls         = false
            protocols {
                port = 80
                type = "Http"
            }
            protocols {
                port = 443
                type = "Https"
            }
        }
    }
}

# Application Gateway
# WAF Policy for Application Gateway 

resource "azurerm_web_application_firewall_policy" "cs-dev1-waf-parent-policy01" {
    location            = azurerm_resource_group.net_rg.location
    name                = var.net_waf_parent_policy01_name
    resource_group_name = azurerm_resource_group.net_rg.name
    tags                = var.global_tags

    managed_rules {
        managed_rule_set {
            type    = "OWASP"
            version = "3.2"
        }
    }

    policy_settings {
        enabled                                   = true
        file_upload_enforcement                   = true
        file_upload_limit_in_mb                   = 100
        js_challenge_cookie_expiration_in_minutes = 30
        max_request_body_size_in_kb               = 128
        mode                                      = "Detection"
        request_body_check                        = true
        request_body_enforcement                  = true
        request_body_inspect_limit_in_kb          = 128
    }
}

# WAF Policy for CS New Portal listeners
resource "azurerm_web_application_firewall_policy" "cs-dev1-waf-policy01" {
    location            = azurerm_resource_group.net_rg.location
    name                = var.net_waf_policy01_name
    resource_group_name = azurerm_resource_group.net_rg.name
    tags                = var.global_tags

    managed_rules {
        managed_rule_set {
            type    = "OWASP"
            version = "3.2"
        }
        exclusion {
            match_variable          = "RequestCookieNames"
            selector                = "__Secure-next-auth.session-token"
            selector_match_operator = "StartsWith"

            excluded_rule_set {
                type    = "OWASP"
                version = "3.2"

                rule_group {
                    excluded_rules  = [
                        "942440",
                        "942450",
                    ]
                    rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
                }
            }
        }
        exclusion {
            match_variable          = "RequestCookieNames"
            selector                = "__Secure-next-auth.pkce.code_verifier"
            selector_match_operator = "StartsWith"

            excluded_rule_set {
                type    = "OWASP"
                version = "3.2"

                rule_group {
                    excluded_rules  = [
                        "942440",
                        "942450",
                    ]
                    rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
                }
            }
        }
        exclusion {
            match_variable          = "RequestArgValues"
            selector                = "callbackUrl"
            selector_match_operator = "Equals"

            excluded_rule_set {
                type    = "OWASP"
                version = "3.2"

                rule_group {
                    excluded_rules  = [
                        "942430",
                    ]
                    rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
                }
            }
        }
        exclusion {
               match_variable          = "RequestArgNames"
               selector                = "comments"
               selector_match_operator = "Equals"

               excluded_rule_set {
                   type    = "OWASP"
                   version = "3.2"

                   rule_group {
                       excluded_rules  = [
                           "942100",
                           "942110",
                           "942120",
                           "942130",
                           "942140",
                           "942150",
                           "942160",
                           "942170",
                           "942180",
                           "942190",
                           "942200",
                           "942210",
                           "942220",
                           "942230",
                           "942240",
                           "942250",
                           "942251",
                           "942260",
                           "942270",
                           "942280",
                           "942290",
                           "942300",
                           "942310",
                           "942320",
                           "942330",
                           "942340",
                           "942350",
                           "942360",
                           "942361",
                           "942370",
                           "942380",
                           "942390",
                           "942400",
                           "942410",
                           "942420",
                           "942421",
                           "942430",
                           "942431",
                           "942432",
                           "942440",
                           "942450",
                           "942460",
                           "942470",
                           "942480",
                           "942490",
                           "942500",
                        ]
                       rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
                    }
                }
            }
    }

    policy_settings {
        enabled                                   = true
        file_upload_enforcement                   = true
        file_upload_limit_in_mb                   = 100
        js_challenge_cookie_expiration_in_minutes = 30
        max_request_body_size_in_kb               = 128
        mode                                      = "Prevention"
        request_body_check                        = true
        request_body_enforcement                  = true
        request_body_inspect_limit_in_kb          = 128
    }

    custom_rules {
        action = "Block"
        enabled = true
        name = var.waf_rule01_name
        priority = var.waf_rule01_priority
        rule_type = "MatchRule"

      match_conditions {
        match_values = var.waf_rule01_condition01_value01
        negation_condition = true
        operator = "IPMatch"
        transforms = []
        match_variables {
            variable_name = "RemoteAddr"
            }
      }
    }
    lifecycle {
        ignore_changes = [
            managed_rules[0].exclusion[0].excluded_rule_set,
            managed_rules[0].exclusion[1].excluded_rule_set,
            managed_rules[0].exclusion[2].excluded_rule_set,
        ]
    }
}

resource "azurerm_application_gateway" "cs-dev1-agw" {
    enable_http2                      = true
    fips_enabled                      = false
    firewall_policy_id                = azurerm_web_application_firewall_policy.cs-dev1-waf-parent-policy01.id
    force_firewall_policy_association = true
    location                          = azurerm_resource_group.net_rg.location
    name                              = var.net_agw_name
    resource_group_name               = azurerm_resource_group.net_rg.name
    tags                              = var.global_tags
    zones                             = [
        "1",
        "2",
        "3",
    ]
      sku {
      capacity = 0
      name     = "WAF_v2"
      tier     = "WAF_v2"
  }

  autoscale_configuration {
      max_capacity = 10
      min_capacity = 0
  }

  backend_address_pool {
      fqdns        = []
      ip_addresses = [ "10.208.1.64" ]
      name         = var.net_agw_beap_name
  }

  backend_http_settings {
      affinity_cookie_name                = "ApplicationGatewayAffinity"
      cookie_based_affinity               = "Disabled"
      host_name                           = null
      name                                = var.net_agw_behttp_name
      path                                = null
      pick_host_name_from_backend_address = false
      port                                = 80
      probe_name                          = "probe01"
      protocol                            = "Http"
      request_timeout                     = 120
      trusted_root_certificate_names      = []
  }

  frontend_ip_configuration {
      name                            = "appGwPublicFrontendIpIPv4"
      private_ip_address              = null
      private_ip_address_allocation   = "Dynamic"
      private_link_configuration_id   = null
      private_link_configuration_name = null
      public_ip_address_id            = azurerm_public_ip.cs_dev01_agw_pip01.id
      subnet_id                       = null
  }

  frontend_ip_configuration {
      name                            = "appGWPrivateFrontendIPv4"
      private_ip_address              = "10.211.0.10"
      private_ip_address_allocation   = "Static"
      private_link_configuration_id   = null
      private_link_configuration_name = null
      subnet_id                       = azurerm_subnet.net_appgw_subnet.id
  }

  frontend_port {
      name = var.net_agw_feport80_name
      port = 80
  }
  frontend_port {
      name = var.net_agw_feport443_name
      port = 443
  }

  gateway_ip_configuration {
      name      = "appGatewayIpConfig"
      subnet_id = azurerm_subnet.net_appgw_subnet.id
  }

  http_listener {
      firewall_policy_id             = azurerm_web_application_firewall_policy.cs-dev1-waf-policy01.id
      frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
      frontend_port_name             = var.net_agw_feport80_name
      host_name                      = null
      host_names                     = []
      name                           = var.net_agw_http_listener_name
      protocol                       = "Http"
      require_sni                    = false
      ssl_certificate_id             = null
      ssl_certificate_name           = null
      ssl_profile_id                 = null
      ssl_profile_name               = null
  }

  http_listener {
      firewall_policy_id             = azurerm_web_application_firewall_policy.cs-dev1-waf-policy01.id
      frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
      frontend_port_name             = var.net_agw_feport443_name
      host_name                      = null
      host_names                     = []
      name                           = var.net_agw_https_listener_name
      protocol                       = "Https"
      ssl_certificate_name           = var.net_agw_ssl_cert_name
  }

  redirect_configuration {
    name = var.net_agw_routing_rule_redirect_name
    redirect_type = "Permanent"
    target_listener_name = var.net_agw_https_listener_name
  }

  request_routing_rule {
      backend_address_pool_name   = var.net_agw_beap_name
      backend_http_settings_name  = var.net_agw_behttp_name
      http_listener_name          = var.net_agw_https_listener_name
      name                        = var.net_agw_routing_rule_name
      priority                    = 1
      redirect_configuration_id   = null
      redirect_configuration_name = null
      rewrite_rule_set_id         = null
      rewrite_rule_set_name       = var.net_agw_rewrite_rule_set01_name
      rule_type                   = "Basic"
      url_path_map_id             = null
      url_path_map_name           = null
  }

  request_routing_rule {
    http_listener_name = var.net_agw_http_listener_name
    name = var.net_agw_routing_rule_redirect_name
    priority = 2
    redirect_configuration_name = var.net_agw_routing_rule_redirect_name
    rule_type = "Basic"
  }

  rewrite_rule_set {
    name = var.net_agw_rewrite_rule_set01_name

    rewrite_rule {
      name = var.net_agw_rewrite_rule_set01_name
      rule_sequence = 100
      
      request_header_configuration {
        header_name = "X-Forwarded-For"
        header_value = "(var_add_x_forwarded_for_proxy)"
        }

      response_header_configuration {
        header_name = "Strict-Transport-Security"
        header_value = "max-age=31536000; includeSubdomains; preload"
      }  
    }
  }

  probe {
    host = "10.208.1.64"
    interval = 30
    name = "probe01"
    path = "/healthz"
    pick_host_name_from_backend_http_settings = "false"
    protocol = "Http"
    timeout = 30
    unhealthy_threshold = 3

    match {
        status_code = [ "200-399", ]
    }

  }

  ssl_certificate {
    name = var.net_agw_ssl_cert_name
    data = filebase64("${path.module}/cert/dev_chartswap_com.pfx")
    password = data.azurerm_key_vault_secret.ssl.value
    
  }
  
  depends_on = [
    azurerm_public_ip.cs_dev01_agw_pip01,
    azurerm_subnet.net_appgw_subnet,
    azurerm_web_application_firewall_policy.cs-dev1-waf-policy01
  ]
}

# App Gateway logging
resource "azurerm_monitor_diagnostic_setting" "agw_diag" {
    name = var.net_agw_diagnostic_name
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_law.id
    target_resource_id = azurerm_application_gateway.cs-dev1-agw.id
    log_analytics_destination_type = "Dedicated"

    enabled_log {
        category = null
        category_group = "allLogs"
    }

    metric {
        category = "AllMetrics"
        enabled = true
    }
}
