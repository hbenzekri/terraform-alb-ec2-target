locals {
  common_tags = {
    "Environment" = var.environment,
    "Application" = var.app_name,
    "Managed_By"  = "Terraform"
  }
}