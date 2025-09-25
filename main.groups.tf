###############################################
# Azure AD Group Creation
# ---------------------------------------
# Creates Azure AD groups from `var.groups` when
# `var.azuread_group_creation_enabled` is true.
#
# The resulting groups can be referenced by role assignments via
# the `group_key_reference` property in `var.role_assignments`.
#
# Permissions:
# The identity running Terraform must have directory permissions
# sufficient to create groups (e.g. Group.ReadWrite.All) and to
# read their object ids for subsequent RBAC role assignments.
###############################################
resource "azuread_group" "this" {
  for_each = { for grp_k, grp_v in var.groups : grp_k => grp_v if var.azuread_group_creation_enabled }

  display_name     = each.value.display_name
  mail_nickname    = lookup(each.value, "mail_nickname", null)
  description      = lookup(each.value, "description", null)
  owners           = lookup(each.value, "owners", [])
  members          = lookup(each.value, "members", [])
  security_enabled = lookup(each.value, "security_enabled", true)
  visibility       = lookup(each.value, "visibility", "Private")
}