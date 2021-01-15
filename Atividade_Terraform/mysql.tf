resource "azurerm_mysql_server" "mysqlserver" {
  name                = "mysqlserver"
  location            = azurerm_resource_group.rg_aula.location
  resource_group_name = azurerm_resource_group.rg_aula.name

  administrator_login          = "mysqladmin"
  administrator_login_password = "@Zur&user3006"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mysqldatabase" {
  name                = "mysqldatabase"
  resource_group_name = azurerm_resource_group.rg_aula.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}