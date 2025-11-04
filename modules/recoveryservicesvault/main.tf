# This is deprecated. Use AzAPI
#resource "azurerm_recovery_services_vault" "rsv" {
#  name                = var.name
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  sku                 = var.sku
#  tags                = var.tags
#
#  soft_delete_enabled = var.soft_delete_enabled
#}

# AzAPI
resource "azapi_resource" "rsv" {
  type      = "Microsoft.RecoveryServices/vaults@2023-02-01"
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_name != null ? azurerm_resource_group.rg.id : null
  tags      = var.tags

  body = jsonencode({
    properties = {
      sku = {
        name = var.sku
      }
      softDeleteFeatureState = var.soft_delete_enabled ? "Enabled" : "Disabled"
    }
  })
}