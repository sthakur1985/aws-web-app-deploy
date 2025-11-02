##############################################
# CloudWatch Module - variables.tf
##############################################

variable "project" {
  description = "Project name for tagging and alarm naming"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name for EC2 alarms"
  type        = string
  default     = ""
}

variable "db_instance_identifier" {
  description = "RDS instance identifier for RDS alarms"
  type        = string
  default     = ""
}

variable "alarm_actions" {
  description = "List of SNS topic ARNs to send alarm notifications"
  type        = list(string)
  default     = []
}

variable "enable_ec2_alarms" {
  description = "Enable EC2 alarms"
  type        = bool
  default     = true
}

variable "enable_rds_alarms" {
  description = "Enable RDS alarms"
  type        = bool
  default     = true
}

variable "ec2_cpu_threshold" {
  description = "Threshold for EC2 CPU utilization alarm (%)"
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold" {
  description = "Threshold for RDS free storage alarm in bytes (default: 2GB)"
  type        = number
  default     = 2000000000
  
  validation {
    condition     = var.rds_free_storage_threshold > 0
    error_message = "RDS free storage threshold must be greater than 0."
  }
}

variable "rds_cpu_threshold" {
  description = "Threshold for RDS CPU utilization alarm (%)"
  type        = number
  default     = 80
}

variable "enable_alb_alarms" {
  description = "Enable ALB alarms"
  type        = bool
  default     = true
}

variable "alb_arn" {
  description = "ALB ARN for monitoring"
  type        = string
  default     = null
}

variable "target_group_arn" {
  description = "Target Group ARN for monitoring"
  type        = string
  default     = null
}

variable "alb_response_time_threshold" {
  description = "ALB response time threshold in seconds"
  type        = number
  default     = 1.0
}

variable "alb_5xx_threshold" {
  description = "ALB 5XX error threshold"
  type        = number
  default     = 10
}
