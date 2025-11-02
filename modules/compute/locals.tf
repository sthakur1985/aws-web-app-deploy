############################################
# Compute Module - Local Values
############################################

locals {
  # Common name prefix for all resources in this module
  name_prefix = "${var.costcenter}-${var.env}-compute"

  # Common tags applied to all resources
  common_tags = {
    Project     = var.costcenter
    Environment = var.env
    Owner       = var.owner
    ManagedBy   = "Terraform"
    Module      = "compute"
  }

  # Default AMI logic: use variable if provided, otherwise fallback to data source
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
}
