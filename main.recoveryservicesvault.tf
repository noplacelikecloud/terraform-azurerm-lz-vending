module "rsv" {
    source = "./modules/recoveryservicesvault"

    for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled }

    name                = rsv_v.name
    location            = rsv_v.location
    resource_group_name = coalesce(
        can(module.resourcegroup[rsv_v.resource_group_key].resource_group_name) ? module.resourcegroup[rsv_v.resource_group_key].resource_group_name : null,
        rsv_v.resource_group_name_existing != null ? rsv_v.resource_group_name_existing : null
    )
    sku                 = rsv_v.sku
    tags                = rsv_v.tags
    soft_delete_enabled = rsv_v.soft_delete_enabled
  
}