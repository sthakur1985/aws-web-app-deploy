variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS deployment"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "EC2 security group ID allowed to access RDS"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage (GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max autoscaled storage (GB)"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type for RDS"
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master DB username"
  type        = string
}

variable "password" {
  description = "Master DB password (used for initial secret creation only)"
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = var.password == null || length(var.password) >= 8
    error_message = "Password must be at least 8 characters long when provided."
  }
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Database port must be between 1024 and 65535."
  }
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

variable "skip_final_snapshot" {
  description = "Skip snapshot on DB deletion (not recommended for production)"
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.skip_final_snapshot))
    error_message = "skip_final_snapshot must be a boolean value (true or false)."
  }
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "SNS topic ARNs for CloudWatch alarms"
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "KMS key ID for RDS encryption"
  type        = string
  default     = null
}

variable "backup_window" {
  description = "Backup window for RDS"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window for RDS"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval (0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 0
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = []
}

variable "create_parameter_group" {
  description = "Create custom parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "parameters" {
  description = "List of parameters for parameter group"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier when skip_final_snapshot is false"
  type        = string
  default     = null

  validation {
    condition     = var.skip_final_snapshot == true || (var.skip_final_snapshot == false && var.final_snapshot_identifier != null)
    error_message = "final_snapshot_identifier must be provided when skip_final_snapshot is false."
  }
}

variable "rds_monitoring_role_arn" {
  description = "ARN of the RDS monitoring role from IAM module"
  type        = string
  default     = null
}
