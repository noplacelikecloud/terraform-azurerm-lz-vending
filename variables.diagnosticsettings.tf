variable "rsv_diagnostic_settings_enabled" {
  description = "Enable Diagnostic Settings"
  type = bool
  default = true
}

variable "vnet_diagnostic_settings_enabled" {
  description = "Enable Diagnostic Settings"
  type = bool
  default = false
}   

variable "diagnostic_settings" {
  description = "A configuration block for diagnostic settings. If `diagnostic_settings_enabled` is true, this block must be provided."
  type = object({
    deploy_log_analytics_workspace = bool # if false, existing_log_analytics_workspace or existing_storage_account must be provided
    log_analytics_workspace_name = optional(string)
    resource_group_key_reference = optional(string)
    resource_group_name_existing = optional(string)
    storage_type = optional(string, "LogAnalytics") # LogAnalytics or StorageAccount
    retention_days = optional(number, 30) # Retention in days for Log Analytics
    existing_log_analytics_workspace_id = optional(string)
    existing_storage_account_id = optional(string)
  })
  default = null

  validation {
    condition = var.diagnostic_settings.deploy_log_analytics_workspace == false ? (var.diagnostic_settings.existing_log_analytics_workspace_id != "" || var.diagnostic_settings.storage_type == "StorageAccount" && var.diagnostic_settings.existing_storage_account_id != "") : true
    error_message = "If you do not want to deploy a new Log Analytics Workspace, you must provide either an existing Log Analytics Workspace ID or an existing Storage Account name."
  }

  validation {
    condition = var.diagnostic_settings.deploy_log_analytics_workspace == true ? (var.diagnostic_settings.log_analytics_workspace_name != "") : true
    error_message = "If you want to deploy a new Log Analytics Workspace, you must provide a name for the Log Analytics Workspace."
  }

  validation {
    condition = contains(["LogAnalytics", "StorageAccount"], var.diagnostic_settings.storage_type)
    error_message = "The storage_type must be either 'LogAnalytics' or 'StorageAccount'."
  }

  validation {
    condition = var.diagnostic_settings.storage_type == "StorageAccount" ? (var.diagnostic_settings.retention_days == 0) : true
    error_message = "If you are using a Storage Account for diagnostics, retention_days must be set to 0."
  }

  validation {
    condition = var.diagnostic_settings.storage_type == "LogAnalytics" ? (var.diagnostic_settings.retention_days > 0) : true
    error_message = "If you are using Log Analytics for diagnostics, retention_days must be greater than 0."
  }

  validation {
    condition = var.diagnostic_settings.deploy_log_analytics_workspace ? (var.diagnostic_settings.resource_group_key_reference != null || var.diagnostic_settings.resource_group_name_existing != null) : true
    error_message = "One of 'resource_group_key_reference' or 'resource_group_name_existing' must be specified."
  }

  nullable    = true
}