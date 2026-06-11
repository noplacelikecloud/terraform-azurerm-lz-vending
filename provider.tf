provider "azurerm" {
  features {}

  subscription_id                 = coalesce(var.subscription_id, var.azurerm_dummy_subscription)
  resource_provider_registrations = "none"
}