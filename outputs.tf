output "budget_resource_id" {
  description = "The created budget resource IDs, expressed as a map."
  value       = { for k, v in module.budget : k => v.budget_resource_id }
}

output "management_group_subscription_association_id" {
  description = <<DESCRIPTION
The management_group_subscription_association_id output is the ID of the management group subscription association.
Value will be null if `var.subscription_management_group_association_enabled` is false.
DESCRIPTION
  value       = var.subscription_management_group_association_enabled ? module.subscription[0].management_group_subscription_association_id : null
}

output "resource_group_resource_ids" {
  description = "The created resource group IDs, expressed as a map."
  value       = { for k, v in module.resourcegroup : k => v.resource_group_resource_id }
}

output "route_table_resource_ids" {
  description = "The created route table resource IDs, expressed as a map."
  value       = { for k, v in module.routetable : k => v.route_table_resource_id }
}

output "subscription_id" {
  description = "The subscription_id is the Azure subscription id that resources have been deployed into."
  value       = local.subscription_id
}

output "subscription_resource_id" {
  description = "The subscription_resource_id is the Azure subscription resource id that resources have been deployed into"
  value       = local.subscription_resource_id
}

output "umi_client_ids" {
  description = <<DESCRIPTION
The client id of the user managed identity.
Value will be null if `var.umi_enabled` is false.
DESCRIPTION
  value       = local.umi_client_ids
}

output "umi_principal_ids" {
  description = <<DESCRIPTION
The principal id of the user managed identity, sometimes known as the object id.
Value will be null if `var.umi_enabled` is false.
DESCRIPTION
  value       = local.umi_principal_ids
}

output "umi_resource_ids" {
  description = <<DESCRIPTION
The Azure resource id of the user managed identity.
Value will be null if `var.umi_enabled` is false.
DESCRIPTION
  value       = local.umi_resource_ids
}

output "umi_tenant_ids" {
  description = <<DESCRIPTION
The tenant id of the user managed identity.
Value will be null if `var.umi_enabled` is false.
DESCRIPTION
  value       = local.umi_tenant_ids
}

output "virtual_networks" {
  description = "A JSON string with virtual network names as keys and objects containing ID and subnets as values."
  value = jsonencode({
    for k, v in module.virtualnetwork.virtual_network_resource_ids : k => {
      id      = v
      subnets = try(module.virtualnetwork.subnet_resource_ids[k], {})
    }
  })
}

output "log_analytics_workspace" {
  description = "The Log Analytics Workspace resource ID."
  value       = module.log_analytics.log_analytics_workspace_id
}

output "recovery_services_vaults" {
  description = "A map of Recovery Services Vault resource IDs, keyed by the var.recovery_services_vaults input map."
  value       = { for k, v in module.recoveryservicesvault : k => v.recovery_services_vault_id }
}