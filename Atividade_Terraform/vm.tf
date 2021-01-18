resource "azurerm_linux_virtual_machine" "vmdb" {
    name                  = "vmDB"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg_mysql.name
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

    computer_name  = "serverDB"
    admin_username = var.user
    admin_password = var.password
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.storagevm.primary_blob_endpoint
    }
 }