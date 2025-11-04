# This is deprecated - Use AzAPI
/* resource "azurerm_storage_account" "lv4_statestorage" {
    count                    = var.deploy_lv4_statestorage_account ? 1 : 0
    name                     = var.lv4_statestorage_account_name
    resource_group_name      = module.resourcegroup.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_2"
    account_kind             = "StorageV2"
    
    
    depends_on = [module.resourcegroup]
} */

# AzAPI
resource "azapi_resource" "lv4_statestorage" {
    count = var.deploy_lv4_statestorage_account ? 1 : 0
    type      = "Microsoft.Storage/storageAccounts@2022-09-01"
    name      = var.lv4_statestorage_account_name
    location  = var.location
    parent_id = coalesce(var.lv4_statestorage_resource_group_existing, module.resourcegroup[var.lv4_statestorage_resource_group_key].resource_group_id)

    body = jsonencode({
        properties = {
            accessTier             = "Hot"
            minimumTlsVersion     = "TLS1_2"
            supportsHttpsTrafficOnly = true
            allowBlobPublicAccess = false
            encryption = {
                services = {
                    blob = {
                        enabled = true
                    }
                }
                keySource = "Microsoft.Storage"
            }
            networkAcls = {
                bypass = "AzureServices"
                defaultAction = "Allow"
            }
        }
        sku = {
            name = "Standard_LRS"
        }
        kind = "StorageV2"
    })
    depends_on = [module.resourcegroup]
}