# Define the namespace and event hub configurations
variable "namespaces" {
    type = list(any)
}

variable "namespace_eventhub_rg" {
    type = string 
}