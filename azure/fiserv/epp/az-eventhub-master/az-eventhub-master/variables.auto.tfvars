namespace_eventhub_rg                = ""

# Define the namespace and event hub configurations
namespaces = [
  {
    name                            = ""
    location                        = ""
    sku                             = "Premium"
    capacity                        = 1
    dedicated_cluster_id            = null
    auto_inflate_enabled            = false
    maximum_throughput_units        = 0  #if auto_inflate_enabled field is set to true then pass the value to the field maximum_throughput_units
    zone_redundant                  = true
    local_authentication_enabled    = true
    public_network_access_enabled   = true
    minimum_tls_version             = "1.2"
    tags                            = {
      "AppName"                     = ""
      "Environment"                 = ""
      "Owner"                       = ""
      "UAID"                        = ""
      "Build"                       = "Terraform"
    }
    network_rulesets                = [
      {
        "default_action"                    = "Allow"
        "ip_rule"                           = []
        "public_network_access_enabled"    = true
        "trusted_service_access_enabled"   = false
        "virtual_network_rule"              = []
      }
    ]
    eventhubs                       = [
      {
        name                 = "eventhuba"
        partition_count      = 2
        message_retention    = 1
        consumer_groups      = ["consumer-groupa", "consumer-groupb"]
      },
      {
        name                 = "eventhubb"
        partition_count      = 4
        message_retention    = 1
        consumer_groups      = ["consumer-groupc", "consumer-groupd"]
      }
    ]
  },
  {
    name                            = "eppnamespaceb"
    location                        = "East US"
    sku                             = "Premium"
    capacity                        = 1
    dedicated_cluster_id            = null
    auto_inflate_enabled            = false
    maximum_throughput_units        = 0  #if auto_inflate_enabled field is set to true then pass the value to the field maximum_throughput_units
    zone_redundant                  = true
    local_authentication_enabled    = true
    public_network_access_enabled   = true
    minimum_tls_version             = "1.2"
    tags                            = {
      "AppName"                     = ""
      "Environment"                 = ""
      "Owner"                       = ""
      "UAID"                        = ""
      "Build"                       = "Terraform"
    }
    network_rulesets                = [
      {
        "default_action"                    = "Allow"
        "ip_rule"                           = []
        "public_network_access_enabled"    = true
        "trusted_service_access_enabled"   = false
        "virtual_network_rule"              = []
      }
    ]
    eventhubs                       = [
      {
        name                 = "eventhubc"
        partition_count      = 3
        message_retention    = 1
        consumer_groups      = ["consumer-groupe" ,"consumer-groupf" ]
      },
      {
        name                 = "eventhubd"
        partition_count      = 2
        message_retention    = 1
        consumer_groups      = []
      }
    ]
  }
]
