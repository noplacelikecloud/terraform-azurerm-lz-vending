# Virtual networking submodule, disabled by default
# Will create a vnet, and optionally peerings and a virtual hub connection
module "virtualnetwork" {
  source           = "./modules/virtualnetwork"
  count            = var.virtual_network_enabled ? 1 : 0
  subscription_id  = local.subscription_id
  virtual_networks = local.virtual_networks
  location         = var.location
  enable_telemetry = !var.disable_telemetry

  depends_on = [
    module.resourcegroup,
    module.routetable,
    module.networksecuritygroup
  ]
}

resource "azurerm_monitor_diagnostic_setting" "vnet" {
    for_each = { for vnet_k, vnet_v in var.virtual_networks : vnet_k => vnet_v if var.virtual_network_enabled && var.vnet_diagnostic_settings_enabled }

    name               = "${each.value.name}-diag"
    target_resource_id = module.virtualnetwork[0].virtual_network_resource_ids[each.key]
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
}