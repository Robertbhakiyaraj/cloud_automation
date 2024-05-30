subscription_id = ""
vnet_name = ""
vnet_resourcegroup_name = ""
default_route_table_name = "transit-rt"

app_name  = ""
env_name =  ""
apm_number = ""


## Define the Application's required Subnet Blocks
cloudapp_subnets_cidrs_map = {
 "filestore"  = ""
 "gpu"        = ""
 "webapi"     = ""
 "appgateway" = ""
 "keyvault"   = ""
}

vm_naming_prefix = ""

vm_specs = {
    GPU = {
        instance_count = 2
        vm_size           = "Standard_NV36ads_A10_v5"
        vm_image          = ""
        data_disk_gb      = 512
        naming_std        = ""
        os_storage_type   = "Standard_LRS"
        os_disk_size      = "128"
        data_storage_type = "Standard_LRS"
        subnet_name       = ""
    }

    STD = {
        instance_count    = 2
        vm_size           = "Standard_D8ads_v5"
        vm_image          = ""
        data_disk_gb      = 512
        naming_std        = ""
        os_storage_type   = "Standard_LRS"
        os_disk_size      = "128"
        data_storage_type = "Standard_LRS"
        subnet_name       = ""
    }
    APP = {
        instance_count    = 2
        vm_size           = "Standard_D4ads_v5"
        vm_image          = ""
        data_disk_gb      = 512
        naming_std        = ""
        os_storage_type   = "Standard_LRS"
        os_disk_size      = "128"
        data_storage_type = "Standard_LRS"
        subnet_name       = ""
    }
}
