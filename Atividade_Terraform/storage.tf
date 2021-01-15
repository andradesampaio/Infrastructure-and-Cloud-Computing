resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.rg_aula.name
    }

    byte_length = 8
}

resource "azurerm_storage_account" "storagevm" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.rg_aula.name
    location                    = azurerm_resource_group.rg_aula.location
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}
