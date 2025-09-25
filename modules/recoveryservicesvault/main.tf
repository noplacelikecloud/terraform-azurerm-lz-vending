resource "azurerm_recovery_services_vault" "rsv" {
    name = var.name
    location = var.location
    resource_group_name = var.resource_group_name
    sku = var.sku
    tags = var.tags

    soft_delete_enabled = var.soft_delete_enabled
}