############################################
# IAM Module - Variables
############################################

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "costcenter" {
  description = "Cost center or owner"
  type        = string
}

variable "enable_rds_monitoring" {
  description = "Enable RDS enhanced monitoring IAM role"
  type        = bool
  default     = false
}