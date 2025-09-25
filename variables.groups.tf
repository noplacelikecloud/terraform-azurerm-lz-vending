variable "azuread_group_creation_enabled" {
    description = "Enable or disable the creation of Azure AD groups."
    type        = bool
    default     = true
}

variable "groups" {
    description = <<DESCRIPTION
A map of the Azure AD groups to create. The map key must be known at the plan stage, e.g. must not be calculated and known only after apply.
### Required fields
- `display_name`: The display name for the group. Changing this forces a new resource to be created. [required]
- `mail_nickname`: The mail nickname for the group. Changing this forces a new resource to be created. [required]
### Optional fields
- `description`: The description for the group. [optional]
- `owners`: A list of user object IDs to assign as owners of the group. [optional]
- `members`: A list of user, group, or service principal object IDs to assign as members of the group. [optional]
- `security_enabled`: A boolean flag to indicate whether the group is a security group. Defaults to true. [optional]
- `visibility`: The visibility of the group. Possible values are 'Private', 'Public', and 'HiddenMembership'. Defaults to 'Private'. [optional]
DESCRIPTION
    type = map(object({
        display_name     = string
        mail_nickname    = string
        description      = optional(string)
        owners           = optional(list(string), [])
        members          = optional(list(string), [])
        security_enabled = optional(bool, true)
        visibility       = optional(string, "Private")
    }))
    nullable    = false
    default     = {}
}