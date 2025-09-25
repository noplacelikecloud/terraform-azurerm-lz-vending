variable "recovery_services_vault_enabled" {
  description = "Whether to create Recovery Services Vaults in the target subscription. Requires `var.recovery_services_vaults`."
  type        = bool
  default     = false
}

variable "recovery_services_vaults" {
  description = <<DESCRIPTION
A map of the Recovery Services Vaults to create. The map key must be known at the plan stage, e.g. must not be calculated and known only after apply.
### Required fields
- `name`: The name of the Recovery Services Vault. Changing this forces a new resource to be created. [required]
- `resource_group_key`: The resource group key from the resource groups map to create the Recovery Services Vault in. [required]
- `resource_group_name_existing`: The name of an existing resource group to create the Recovery Services Vault in. [optional]
**One of `resource_group_key` or `resource_group_name_existing` must be specified.**
### Location
- `location`: The supported Azure location where the resource exists. Changing this forces a new resource to be created.
### SKU
- `sku`: The SKU of the Recovery Services Vault. Possible values are 'Standard' and 'Premium'. Defaults to 'Standard'. [optional]
### Tags
- `tags`: A map of tags to apply to the Recovery Services Vault. [optional - default empty]
### Soft Delete
- `soft_delete_enabled`: Specifies whether soft delete is enabled for the Recovery Services Vault. Defaults to true. [optional]
DESCRIPTION
  type = map(object({
    name                         = string
    resource_group_key           = optional(string)
    resource_group_name_existing = optional(string)
    location                     = optional(string)
    sku                          = optional(string, "Standard")
    tags                         = optional(map(string))
    soft_delete_enabled          = optional(bool, true)
  }))
  nullable = false
  default  = {}

  validation {
    condition = alltrue([
      for k, v in var.recovery_services_vaults :
      (try(v.resource_group_key, null) != null) || (try(v.resource_group_name_existing, null) != null)
    ])
    error_message = "One of 'resource_group_key' or 'resource_group_name_existing' must be specified for all recovery services vaults."
  }
}