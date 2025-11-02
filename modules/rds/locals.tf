############################################
# RDS Module - Local Values
############################################

locals {
  common_tags = {
    Project    = var.project
    ManagedBy  = "Terraform"
    Module     = "rds"
  }
}