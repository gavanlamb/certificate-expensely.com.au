variable "environment" {
  type = string
}
variable "region" {
  type = string
}

variable "domain_name" {
  type = string
  default = null
}

locals {
  default_tags = {
    Application = "Expensely"
    Team = "Expensely Core"
    ManagedBy = "Terraform"
    Environment = var.environment
  }
}
