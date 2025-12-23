# Azure Virtual Network Manager (AVNM) - Automation Hub & Spoke
Ce dépôt contient une configuration Terraform complète pour automatiser la gestion d'une topologie réseau Hub & Spoke sur Azure à l'aide de Virtual Network Manager (AVNM).

L'intérêt principal de cette solution est l'adhésion dynamique : les réseaux (VNETs) rejoignent automatiquement la topologie dès qu'ils portent un tag spécifique, sans aucune modification du code Terraform central.

## 🚀 Fonctionnalités
- Gestion centralisée : Un seul point de contrôle pour tous les peerings.
- Adhésion Dynamique : Utilisation d'Azure Policy pour détecter les VNETs avec le tag Env: Prod.
- Sécurité renforcée : Prêt pour l'ajout de règles d'administration de sécurité globales (Security Admin Rules).
- Zéro maintenance de peering : Plus besoin de gérer les ressources azurerm_virtual_network_peering manuellement.

## 📂 Structure du projet

|Nom du Fichier|Rôle & Responsabilité|
|---|---|
|providers.tf|Définit les sources des providers (AzureRM) et les versions minimales requises.|
|variables.tf|"Centralise les paramètres (région, noms, valeur du tag Env) pour faciliter la réutilisation."|
|main.tf|Contient le groupe de ressources et les réseaux virtuels (VNet Hub et Spoke de test).|
|avnm_core.tf|Déploie l'instance Azure Virtual Network Manager et définit les groupes réseaux (Network Groups).|
|avnm_policy.tf|Gère l'automatisation via Azure Policy : définit la règle d'adhésion dynamique et les droits RBAC.|
|avnm_configs.tf|Définit la topologie (Hub & Spoke) et contient le bloc de déploiement (commit) des configurations.|
|outputs.tf|"Expose les IDs importants (AVNM, Hub) pour une utilisation dans d'autres modules ou scripts."|
|.gitignore|"(Optionnel) Liste les fichiers à exclure du dépôt Git (fichiers d'état local .tfstate, dossiers .terraform)."|

## 🛠️ Pré-requis
- Terraform >= 1.3.0
- Azure CLI
- Un abonnement Azure avec les droits `Owner` ou `User Access Administrator` (nécessaire pour les assignations de rôles RBAC de la Policy).

## 💻 Utilisation

### Initialiser le projet
`terraform init`

### Visualiser les changements
`terraform plan`

### Déployer l'infrastructure
`terraform apply -auto-approve`

## 🔍 Comment ça marche ?
Une fois déployé, le système surveille votre abonnement. 
Pour tester l'automatisation :

1. Créez un nouveau VNET (via Portail ou CLI).

2. Ajoutez-lui le tag : Env = Prod.

3. Azure Policy va détecter ce VNET et l'ajouter au Network Group AVNM.

4. AVNM créera automatiquement le peering bidirectionnel avec le VNET Hub défini dans avnm_configs.tf.

**Note** : Le processus d'évaluation d'Azure Policy peut prendre entre 5 et 15 minutes avant que le peering n'apparaisse.

## 🛡️ Sécurité
Le code inclut une ressource azurerm_role_assignment. Elle permet à l'identité managée de l'Azure Policy d'interagir avec le Network Manager. C'est une étape cruciale souvent oubliée qui garantit le principe du moindre privilège.