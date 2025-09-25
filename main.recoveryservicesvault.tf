module "rsv" {
  source = "./modules/recoveryservicesvault"

  for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled }

  name     = each.value.name
  location = coalesce(each.value.location, var.location)
  resource_group_name = coalesce(
    can(module.resourcegroup[each.value.resource_group_key].resource_group_name) ? module.resourcegroup[each.value.resource_group_key].resource_group_name : null,
    each.value.resource_group_name_existing != null ? each.value.resource_group_name_existing : null
  )
  sku                 = each.value.sku
  tags                = each.value.tags
  soft_delete_enabled = each.value.soft_delete_enabled
}