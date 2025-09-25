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

resource "azurerm_monitor_diagnostic_setting" "rsv" {
    for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled && var.rsv_diagnostic_settings_enabled }
    
    name               = "${each.value.name}-diag"
    target_resource_id = module.rsv[each.key].recovery_services_vault_id
    log_analytics_workspace_id = coalesce(
        var.diagnostic_settings.existing_log_analytics_workspace_id != null ? var.diagnostic_settings.existing_log_analytics_workspace_id : null,
        var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" ? azurerm_log_analytics_workspace.this[0].id : null
    )
    storage_account_id = can(var.diagnostic_settings.storage_account_id) && var.diagnostic_settings.storage_account_id != null && var.diagnostic_settings.storage_type == "StorageAccount" ? var.diagnostic_settings.storage_account_id : null

    enabled_log {
        category = "AuditEvent"
    }

    enabled_metric {
        category = "AllMetrics"
    }

    depends_on = [
        module.rsv,
        azurerm_log_analytics_workspace.this
    ]

}