resource "azurerm_resource_group" "rg_mysql" {
    name     = "mysqlResourceGroup"
    location = var.location
}