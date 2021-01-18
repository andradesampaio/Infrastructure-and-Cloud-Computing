resource "azurerm_virtual_network" "vnet_mysql" {
    name                = "myVnet"
    address_space       = ["10.80.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_mysql.name

    depends_on = [ azurerm_resource_group.rg_mysql ]
}

resource "azurerm_subnet" "mysubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.rg_mysql.name
    virtual_network_name = azurerm_virtual_network.vnet_mysql.name
    address_prefixes       = ["10.80.4.0/24"]

    depends_on = [  azurerm_resource_group.rg_mysql, 
                    azurerm_virtual_network.vnet_mysql ]
}

resource "azurerm_public_ip" "mypublicip" {
    name                         = "mypublicip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg_mysql.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "mynsg" {
    name                = "myNetworkSecurityGroup"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg_mysql.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

     security_rule {
        name                       = "HTTPInbound"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPOutbound"
        priority                   = 1003
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "mynic" {
    name                        = "myNIC"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg_mysql.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.mysubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.mypublicip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsga" {
    network_interface_id      = azurerm_network_interface.mynic.id
    network_security_group_id = azurerm_network_security_group.mynsg.id
}

data "azurerm_public_ip" "ip_data_db" {
  name                         = azurerm_public_ip.mypublicip.name
  resource_group_name          = azurerm_resource_group.rg_mysql.name
}