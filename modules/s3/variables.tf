############################################
# S3 Module - Variables
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

