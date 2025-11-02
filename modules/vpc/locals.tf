############################################
# VPC Module - Local Values
############################################

locals {
  # Common tags applied to all resources
  common_tags = {
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
    ManagedBy   = "Terraform"
    Module      = "vpc"
  }
  
  # EIP specific tags
  eip_tags = {
    Environment = var.env
    Project     = var.project
    CostCenter  = var.costcenter
    ManagedBy   = "Terraform"
    Module      = "vpc"
    Type        = "NAT-EIP"
  }
  
  # Subnet validation
  max_subnets = length(data.aws_availability_zones.available.names)
  
  # NAT Gateway count optimization
  nat_gateway_count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0
}