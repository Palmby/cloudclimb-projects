resource "azurerm_network_security_group" "nsg-mainvnet" {
  name                = "nsg-mainvnet-prod-eastus-001"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name

  security_rule {
    name = "allowSSH"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["22"]
    source_address_prefix = "<mypublicip>/32"
    destination_address_prefix = "10.0.1.20"
  }

}


resource "azurerm_virtual_network" "Main_VNET" {
  name                = "vnet-prod-main-eastus-001"
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name
  
  subnet {
    name             = "Application"
    address_prefixes = ["10.0.1.0/24"]
    security_group = azurerm_network_security_group.nsg-mainvnet.id
  }

  subnet {
    name             = "Data"
    address_prefixes = ["10.0.2.0/24"]
    security_group = azurerm_network_security_group.nsg-mainvnet.id
  }

  subnet {
    name             = "Management"
    address_prefixes = ["10.0.3.0/24"]
    security_group = azurerm_network_security_group.nsg-mainvnet.id
  }

  tags = {
    environment = "production"
    Purpose     = "project"
  }
}

resource "azurerm_network_interface" "ubuntuVMNIC" {
  name                = "ubuntuNIC"
  location            = "eastus"
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name

  ip_configuration {
    name                          = "application"
    subnet_id                     = one([for s in azurerm_virtual_network.Main_VNET.subnet : s.id if s.name == "Application"])
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.20"
  }
}