locals {
    subnet_details = {
        "subnet_name" : module.clouddb_subnets.subnet_name[0]
        "subnet_id" : module.clouddb_subnets.subnet_id[0] ,
        "subnet_prefix" : module.clouddb_subnets.subnet_address_prefixes[0]
    }
}