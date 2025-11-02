############################################
# Route53 Module - Variables
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

variable "domain_name" {
  description = "Domain name for DNS records"
  type        = string
  default     = null
}

variable "create_hosted_zone" {
  description = "Whether to create a new hosted zone"
  type        = bool
  default     = false
}

variable "hosted_zone_id" {
  description = "Existing hosted zone ID (required if create_hosted_zone is false)"
  type        = string
  default     = null
}

variable "alb_dns_name" {
  description = "ALB DNS name for A record"
  type        = string
  default     = null
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID"
  type        = string
  default     = null
}

variable "alb_subdomain" {
  description = "Subdomain for ALB (optional, defaults to apex domain)"
  type        = string
  default     = null
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
  default     = null
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  type        = string
  default     = null
}

variable "cdn_subdomain" {
  description = "Subdomain for CDN (defaults to 'cdn')"
  type        = string
  default     = "cdn"
}