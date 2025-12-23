# Définition de la règle d'adhésion
resource "azurerm_policy_definition" "avnm_membership" {
  name         = "policy-avnm-prod-membership"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AVNM: Enrôlement automatique basé sur le Tag Env"

  policy_rule = jsonencode({
    "if": {
      "allOf": [
        { "field": "type", "equals": "Microsoft.Network/virtualNetworks" },
        { "field": "tags['Env']", "equals": var.target_tag_value }
      ]
    },
    "then": {
      "effect": "addToNetworkGroup",
      "details": { "networkGroupId": azurerm_network_manager_network_group.spokes.id }
    }
  })
}

# Assignation de la politique
resource "azurerm_subscription_policy_assignment" "avnm_assign" {
  name                 = "assign-avnm-prod"
  policy_definition_id = azurerm_policy_definition.avnm_membership.id
  subscription_id      = data.azurerm_subscription.current.id
  location             = var.location
  identity { type = "SystemAssigned" }
}

# Permission pour que la Policy puisse modifier l'AVNM
resource "azurerm_role_assignment" "policy_to_avnm" {
  scope                = azurerm_network_manager.main.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_subscription_policy_assignment.avnm_assign.identity[0].principal_id
}