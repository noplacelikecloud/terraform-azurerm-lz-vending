variable "azuread_group_creation_enabled" {
  description = <<DESCRIPTION
Enable or disable the creation of Azure AD groups defined in `var.groups`.
If disabled, no `azuread_group` resources will be created and any
`group_key_reference` in role assignments will be ignored (the module
will fall back to the explicit `principal_id`).
DESCRIPTION
  type        = bool
  default     = true
}

variable "groups" {
  description = <<DESCRIPTION
A map of Azure AD groups to create. The map key must be known at plan time (static key set).

Required fields:
- `display_name` (string) – Display name (forces recreation if changed)
- `mail_nickname` (string) – Mail nickname (forces recreation if changed)

Optional fields:
- `description` (string)
- `owners` (list(string)) – Object IDs of users to set as owners
- `members` (list(string)) – Object IDs of users / groups / service principals as members
- `security_enabled` (bool, default true)
- `visibility` (string, one of `Private`, `Public`, `HiddenMembership`; default `Private`)

Usage:
```hcl
groups = {
    platform_engineers = {
        display_name  = "Platform Engineers"
        mail_nickname = "plateng"
        owners        = ["00000000-0000-0000-0000-000000000001"]
    }
}
```
DESCRIPTION
  type = map(object({
    display_name     = string
    mail_nickname    = optional(string)
    description      = optional(string)
    owners           = optional(list(string), [])
    members          = optional(list(string), [])
    security_enabled = optional(bool, true)
    visibility       = optional(string, "Private")
  }))
  nullable = false
  default  = {}
}