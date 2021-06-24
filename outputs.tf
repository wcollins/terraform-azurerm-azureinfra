output "vnet_id" {
  description = "Virtual network IDs"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "VNet location"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  description = "VNet address space"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_id" {
  description = "List of subnet IDs"
  value       = azurerm_subnet.subnet.*.id
}

output "virtual_machine_id" {
  description = "List of virtual machine IDs"
  value       = azurerm_linux_virtual_machine.vm.*.id
}

output "private_ip_address" {
  description = "List of virtual machine private IP addresses"
  value       = azurerm_linux_virtual_machine.vm.*.private_ip_address
}