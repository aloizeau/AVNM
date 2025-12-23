# Instance AVNM
resource "azurerm_network_manager" "main" {
  name                = "avnm-global-manager"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  scope_accesses      = ["Connectivity", "SecurityAdmin"]

  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
}

# Groupe Réseau pour les Spokes
resource "azurerm_network_manager_network_group" "spokes" {
  name               = "ng-production-spokes"
  network_manager_id = azurerm_network_manager.main.id
}