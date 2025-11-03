resource "azurerm_storage_account" "lv4_statestorage" {
    count                    = var.deploy_lv4_statestorage_account ? 1 : 0
    name                     = var.lv4_statestorage_account_name
    resource_group_name      = module.resourcegroup.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_2"
    account_kind             = "StorageV2"
    
    
    depends_on = [module.resourcegroup]
}