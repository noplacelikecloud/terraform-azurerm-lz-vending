module "rsv" {
  source = "./modules/recoveryservicesvault"

  for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled }

  name     = each.value.name
  location = coalesce(each.value.location, var.location)
  parent_id = "/subscriptions/${local.subscription_id}/resourceGroups/${can(module.resourcegroup[each.value.resource_group_key].resource_group_name) ? module.resourcegroup[each.value.resource_group_key].resource_group_name : null}/providers/Microsoft.RecoveryServices/vaults/${each.value.name}"
  sku                 = each.value.sku
  tags                = each.value.tags
  soft_delete_enabled = each.value.soft_delete_enabled
}

# AzureRM is deprecated - Use AzAPI
/* resource "azurerm_monitor_diagnostic_setting" "rsv" {
    for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled && var.rsv_diagnostic_settings_enabled }
    
    name               = "${each.value.name}-diag"
    target_resource_id = module.rsv[each.key].recovery_services_vault_id
    log_analytics_workspace_id = coalesce(
        var.diagnostic_settings.existing_log_analytics_workspace_id != null ? var.diagnostic_settings.existing_log_analytics_workspace_id : null,
        var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" ? azurerm_log_analytics_workspace.this[0].id : null
    )
    storage_account_id = can(var.diagnostic_settings.storage_account_id) && var.diagnostic_settings.storage_account_id != null && var.diagnostic_settings.storage_type == "StorageAccount" ? var.diagnostic_settings.storage_account_id : null

    enabled_log {
        category_group = "allLogs"
    }

    enabled_metric {
        category = "AllMetrics"
    }

    depends_on = [
        module.rsv,
        azurerm_log_analytics_workspace.this
    ]

} */

# AzAPI Diagnostic Settings for Recovery Services Vault
resource "azapi_resource" "rsv_diagnostic_setting" {
    for_each = { for rsv_k, rsv_v in var.recovery_services_vaults : rsv_k => rsv_v if var.recovery_services_vault_enabled && var.rsv_diagnostic_settings_enabled }
    type      = "Microsoft.Insights/diagnosticSettings@2021-05-01-preview"
    name      = "${each.value.name}-diag"
    parent_id = module.rsv[each.key].recovery_services_vault_id
    body = jsonencode({
        properties = {
            workspaceId = coalesce(
                var.diagnostic_settings.existing_log_analytics_workspace_id != null ? var.diagnostic_settings.existing_log_analytics_workspace_id : null,
                var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" ? azapi_resource.law[0].id : null
            )
            storageAccountId = can(var.diagnostic_settings.storage_account_id) && var.diagnostic_settings.storage_account_id != null && var.diagnostic_settings.storage_type == "StorageAccount" ? var.diagnostic_settings.storage_account_id : null
            logs = [
                {
                    category = "AllLogs"
                    enabled  = true
                    retentionPolicy = {
                        enabled = false
                        days    = 0
                    }
                }
            ]
            metrics = [
                {
                    category = "AllMetrics"
                    enabled  = true
                    retentionPolicy = {
                        enabled = false
                        days    = 0
                    }
                }
            ]
        }
    })
    depends_on = [
        module.rsv,
        azapi_resource.law
    ]
}