resource "azurerm_linux_virtual_machine" "myvm" {
    name                  = "myVM"
    location              = azurerm_resource_group.rg_aula.location
    resource_group_name   = azurerm_resource_group.rg_aula.name
    network_interface_ids = [azurerm_network_interface.mynic.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmMysql"
    admin_username = "azureuser"
    admin_password = "@Zur&user3006"
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.storagevm.primary_blob_endpoint
    }
    
}