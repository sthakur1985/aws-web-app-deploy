############################################
# ALB Module - Variables
############################################

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least 2 public subnets are required for ALB high availability."
  }
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.env)
    error_message = "Environment must be one of: dev, test, staging, prod."
  }
}

variable "costcenter" {
  description = "Owner or team name"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "ARN of SSL certificate for HTTPS listener (optional)"
  type        = string
  default     = null

  validation {
    condition     = var.ssl_certificate_arn == null || can(regex("^arn:aws:acm:", var.ssl_certificate_arn))
    error_message = "SSL certificate ARN must be a valid ACM certificate ARN starting with 'arn:aws:acm:' when provided."
  }
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "enable_access_logs" {
  description = "Enable ALB access logs"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
  default     = ""

  validation {
    condition     = var.enable_access_logs == false || (var.enable_access_logs == true && var.access_logs_bucket != "")
    error_message = "S3 bucket name is required when access logs are enabled."
  }
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.allowed_cidr_blocks) > 0
    error_message = "At least one CIDR block must be specified for ALB access."
  }
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid header fields for security. Set to false only for legacy applications that require non-standard headers"
  type        = bool
  default     = true
}
