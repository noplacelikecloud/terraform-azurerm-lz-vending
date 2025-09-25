variable "role_assignment_enabled" {
  type = bool
  description = <<DESCRIPTION
Enable creation of RBAC role assignments defined in `var.role_assignments`.
Set to `false` to skip all role assignment resources (useful for phased
deployments or when only networking / identity scaffolding is desired).
DESCRIPTION
  default = false
}

variable "role_assignments" {
  type = map(object({
    definition                = string
    principal_id              = optional(string)
    group_key_reference       = optional(string)
    relative_scope            = optional(string)
    condition                 = optional(string)
    condition_version         = optional(string)
    principal_type            = optional(string)
    definition_lookup_enabled = optional(bool, true)
    use_random_uuid           = optional(bool, false)
  }))
  description = <<DESCRIPTION
Map of role assignment objects.

Principal Resolution:
If `group_key_reference` is supplied and resolves to a created group key in
`var.groups` (with group creation enabled), that group's object id is used.
Otherwise `principal_id` must be supplied.

Fields:
- `definition` (string, required) – Role definition name or resource id.
- `principal_id` (string, optional) – Object id (user / group / service principal / managed identity).
- `group_key_reference` (string, optional) – Key referencing a group defined in `var.groups`.
- `relative_scope` (string, optional) – Suffix appended to subscription id (e.g. `/resourceGroups/rg1`).
- `condition` / `condition_version` (optional) – ABAC condition settings.
- `principal_type` (string, optional) – Required when using ABAC conditions (User, Group, ServicePrincipal, Device, ForeignGroup).
- `definition_lookup_enabled` (bool, default true) – Resolve `definition` name to id.
- `use_random_uuid` (bool, default false) – Randomize name to avoid recreation on value changes.

Example:
```hcl
role_assignments = {
  contributors_group = {
    group_key_reference       = "platform_engineers"
    definition                = "Contributor"
    relative_scope            = ""
    definition_lookup_enabled = true
  }
  storage_reader_user = {
    principal_id   = "11111111-1111-1111-1111-111111111111"
    definition     = "Reader"
    relative_scope = "/resourceGroups/app1-rg"
  }
}
```
DESCRIPTION
  nullable = false
  default  = {}

  validation {
    condition = alltrue([
      for k, v in var.role_assignments :
      (try(v.principal_id, null) != null) || (try(v.group_key_reference, null) != null)
    ])
    error_message = "Each role assignment must define either principal_id or group_key_reference."
  }
}

variable "wait_for_umi_before_umi_role_assignment_operations" {
  type = object({
    create  = optional(string, "30s")
    destroy = optional(string, "0s")
  })
  default     = {}
  description = <<DESCRIPTION
The duration to wait after creating a user managed identity before performing role assignment operations.
DESCRIPTION
}
