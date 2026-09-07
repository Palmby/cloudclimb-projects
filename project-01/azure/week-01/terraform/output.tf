
output "resource_group_name" {
  description = "Name of the existing resource group the resources are deployed into"
  value       = data.azurerm_resource_group.cloud_project_resource_group.name
}

output "resource_group_location" {
  description = "Azure region of the resource group"
  value       = data.azurerm_resource_group.cloud_project_resource_group.location
}

# Virtual network
output "vnet_name" {
  description = "Name of the created virtual network"
  value       = azurerm_virtual_network.Main_VNET.name
}

output "vnet_id" {
  description = "Resource ID of the virtual network"
  value       = azurerm_virtual_network.Main_VNET.id
}

output "vnet_address_space" {
  description = "CIDR blocks assigned to the virtual network"
  value       = azurerm_virtual_network.Main_VNET.address_space
}

output "subnet_ids" {
  description = "Map of subnet name => subnet resource ID"
  value       = { for s in azurerm_virtual_network.Main_VNET.subnet : s.name => s.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet name => assigned address prefixes"
  value       = { for s in azurerm_virtual_network.Main_VNET.subnet : s.name => s.address_prefixes }
}

# Network security group
output "nsg_name" {
  description = "Name of the created network security group"
  value       = azurerm_network_security_group.nsg-mainvnet.name
}

output "nsg_id" {
  description = "Resource ID of the network security group"
  value       = azurerm_network_security_group.nsg-mainvnet.id
}

# Single rolled-up view of everything this configuration creates
output "created_resources" {
  description = "Summary of all resources created by this configuration"
  value = {
    virtual_network = {
      name          = azurerm_virtual_network.Main_VNET.name
      id            = azurerm_virtual_network.Main_VNET.id
      location      = azurerm_virtual_network.Main_VNET.location
      address_space = azurerm_virtual_network.Main_VNET.address_space
      subnets       = { for s in azurerm_virtual_network.Main_VNET.subnet : s.name => s.address_prefixes }
    }
    network_security_group = {
      name     = azurerm_network_security_group.nsg-mainvnet.name
      id       = azurerm_network_security_group.nsg-mainvnet.id
      location = azurerm_network_security_group.nsg-mainvnet.location
    }
  }
}
