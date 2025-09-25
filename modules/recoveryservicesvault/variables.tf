variable "name" {
    description = "The name of the Recovery Services Vault."
    type        = string
}

variable "location" {
    description = "The Azure location where the Recovery Services Vault should be created."
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group in which to create the Recovery Services Vault."
    type        = string
}

variable "sku" {
    description = "The SKU of the Recovery Services Vault. Possible values are 'Standard' and 'Premium'."
    type        = string
    default     = "Standard"
}

variable "tags" {
    description = "A map of tags to assign to the resource."
    type        = map(string)
    default     = {}
}

variable "soft_delete_enabled" {
    description = "Specifies whether soft delete is enabled for the Recovery Services Vault. Defaults to true."
    type        = bool
    default     = true
}