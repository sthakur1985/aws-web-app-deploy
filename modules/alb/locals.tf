############################################
# ALB Module - Local Values
############################################

locals {
  # Common name prefix for all resources in this module
  name_prefix = "${var.project_name}-${var.env}-alb"

  # Common tags applied to all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.env
    CostCenter  = var.costcenter
    ManagedBy   = "Terraform"
    Module      = "alb"
  }


}
