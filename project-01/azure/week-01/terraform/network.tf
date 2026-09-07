resource "azurerm_network_security_group" "nsg-mainvnet" {
  name                = "nsg-mainvnet-prod-eastus-001"
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name
}


resource "azurerm_virtual_network" "Main_VNET" {
  name                = "vnet-prod-main-eastus-001"
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name
  subnet {
    name             = "Application"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "Data"
    address_prefixes = ["10.0.2.0/24"]
  }

  subnet {
    name             = "Management"
    address_prefixes = ["10.0.3.0/24"]
  }

  tags = {
    environment = "production"
    Purpose     = "project"
  }
}