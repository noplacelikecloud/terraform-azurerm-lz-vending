variable "location" {
  type        = string
  description = <<DESCRIPTION
The default location of resources created by this module.
Virtual networks will be created in this location unless overridden by the `location` attribute.
DESCRIPTION
  nullable    = false
}

variable "disable_telemetry" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
To disable tracking, we have included this variable with a simple boolean flag.
The default value is `false` which does not disable the telemetry.
If you would like to disable this tracking, then simply set this value to true and this module will not create the telemetry tracking resources and therefore telemetry tracking will be disabled.

For more information, see the [wiki](https://aka.ms/lz-vending/tf/telemetry)

E.g.

```terraform
module "lz_vending" {
  source  = "Azure/lz-vending/azurerm"
  version = "<version>" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  # ... other module variables

  disable_telemetry = true
}
```
DESCRIPTION
  nullable    = false
}

variable "azurerm_dummy_subscription" {
  type        = string
  description = <<DESCRIPTION
  AzureRM requires an active subscription to initialize the provider.
  This variable is used to provide a dummy subscription ID to allow the provider to initialize whenever no subscription is provided. (Gets vendored by this module)
  DESCRIPTION
  nullable    = true
  default = null
}