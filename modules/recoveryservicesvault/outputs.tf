output "recovery_services_vault_id" {
    description = "The ID of the Recovery Services Vault."
    value       = azurerm_recovery_services_vault.rsv.id
}