variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" { type = string }
variable "env" { type = string }
variable "project" { type = string }
variable "costcenter" { type = string }
variable "azs" {
type = list(string)
default = []
}


variable "public_subnet_cidrs" {
type = list(string)
default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_subnet_cidrs" {
type = list(string)
default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 14
}