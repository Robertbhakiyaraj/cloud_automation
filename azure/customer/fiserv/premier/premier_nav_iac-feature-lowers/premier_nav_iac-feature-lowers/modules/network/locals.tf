locals {
    subnet_details = {
        "subnet_name" : module.cloudapp_subnets.subnet_name[0]
        "subnet_id" : module.cloudapp_subnets.subnet_id[0] ,
        "subnet_prefix" : module.cloudapp_subnets.subnet_address_prefixes[0]
    }
}