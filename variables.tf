variable "location" {
  type    = string
  default = "France Central"
}

variable "rg_name" {
  type    = string
  default = "rg-avnm-automation"
}

variable "target_tag_value" {
  type        = string
  default     = "Prod"
  description = "Le tag 'Env' qui déclenchera l'ajout automatique au groupe réseau"
}