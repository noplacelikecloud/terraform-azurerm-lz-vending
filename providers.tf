provider "azurerm" {
    features {}
    
    # Ensure the provider uses the subscription ID from the local variable
    subscription_id = local.subscription_id
    resource_provider_registrations = "none"   
}