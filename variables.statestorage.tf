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