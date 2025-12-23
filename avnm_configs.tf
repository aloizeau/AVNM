# Configuration Hub & Spoke
resource "azurerm_network_manager_connectivity_configuration" "hub_spoke" {
  name                  = "config-connectivity-hubspoke"
  network_manager_id    = azurerm_network_manager.main.id
  connectivity_topology = "HubAndSpoke"

  hub {
    resource_id   = azurerm_virtual_network.hub.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }

  applies_to_group {
    group_connectivity = "None" # "DirectlyConnected" pour permettre Spoke-to-Spoke
    network_group_id   = azurerm_network_manager_network_group.spokes.id
  }
}

# Déploiement effectif (Le "Commit")
resource "azurerm_network_manager_deployment" "commit" {
  network_manager_id = azurerm_network_manager.main.id
  location           = var.location
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.hub_spoke.id]

  # On force le redéploiement si la config change
  triggers = {
    config_id = azurerm_network_manager_connectivity_configuration.hub_spoke.id
  }

  depends_on = [azurerm_role_assignment.policy_to_avnm]
}