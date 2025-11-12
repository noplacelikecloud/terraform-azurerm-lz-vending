# Deprecated - Use AzAPI
#resource "azurerm_log_analytics_workspace" "this" {
#  count               = var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" ? 1 : 0
#  name                = var.diagnostic_settings.log_analytics_workspace_name
#  location            = var.location
#  resource_group_name = coalesce(
#    can(module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name) ? module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name : null,
#    var.diagnostic_settings.resource_group_name_existing != null ? var.diagnostic_settings.resource_group_name_existing : null
#  )
#  sku                 = "PerGB2018"
#  retention_in_days   = var.diagnostic_settings.retention_days
#}

# import resource group by name using azapi_resource
data "azapi_resource" "rg" {
  count = var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" && var.diagnostic_settings.resource_group_name_existing != null ? 1 : 0

  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = coalesce(
    can(module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name) ? module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name : null,
    var.diagnostic_settings.resource_group_name_existing != null ? var.diagnostic_settings.resource_group_name_existing : null
  )
}

# AzAPI
resource "azapi_resource" "law" {
  count = var.diagnostic_settings.deploy_log_analytics_workspace && var.diagnostic_settings.storage_type == "LogAnalytics" ? 1 : 0

  type      = "Microsoft.OperationalInsights/workspaces@2022-10-01"
  name      = var.diagnostic_settings.log_analytics_workspace_name
  location  = var.location
  parent_id = "/subscriptions/${local.subscription_id}/resourceGroups/${coalesce(
    can(module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name) ? module.resourcegroup[var.diagnostic_settings.resource_group_key_reference].resource_group_name : null,
    var.diagnostic_settings.resource_group_name_existing != null ? var.diagnostic_settings.resource_group_name_existing : null
  )}"

  body = {
    properties = {
      sku = {
        name = "PerGB2018"
      }
      retentionInDays = var.diagnostic_settings.retention_days
    }
  }
}