variable "lv4_statestorage_account_name" {
    description = "The name of the state storage account for level 4 deployments."
    type        = string
    default     = ""
}

variable "deploy_lv4_statestorage_account" {
    description = "Whether to deploy the level 4 state storage account."
    type        = bool
    default     = false
}

variable "lv4_statestorage_resource_group_existing" {
    description = "The name of an existing resource group to deploy the level 4 state storage account into. If not provided, the storage account will be deployed into the main resource group."
    type        = string
    default     = null
}

variable "lv4_statestorage_resource_group_key" {
    description = "The key reference to the resource group in which to deploy the level 4 state storage account, if using multiple resource groups."
    type        = string
    default     = null
}