terraform {
  required_version = "~> 1.10"
  required_providers {
    # AzAPI provider used for subscription creation & generic ARM interaction (role definition lookup, etc.)
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.2"
    }
    # AzureRM provider required for data sources / potential resource usage in sub-modules.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.45"
    }
    # Time provider used for introducing strategic delays (e.g., waiting after UMI creation before assigning roles).
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
    # AzureAD provider added to support optional Azure AD group creation consumed by role assignments.
    # Ensure the executing principal has directory permissions (e.g. to create groups & read their object IDs).
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.29"
    }
  }
}
