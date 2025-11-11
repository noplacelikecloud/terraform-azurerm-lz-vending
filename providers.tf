provider "azurerm" {
    features {}

    subscription_id = coalesce(module.subscription[0].subscription_id, var.subscription_id)
}