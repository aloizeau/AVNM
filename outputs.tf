output "avnm_id" {
  value = azurerm_network_manager.main.id
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "policy_assignment_identity" {
  value = azurerm_subscription_policy_assignment.avnm_assign.identity[0].principal_id
}