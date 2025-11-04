output "recovery_services_vault_id" {
    description = "The ID of the Recovery Services Vault."
    value       = azapi_resource.rsv.id
}