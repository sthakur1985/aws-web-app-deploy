############################################
# Outputs
############################################
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.rds_endpoint
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for static content"
  value       = var.enable_static_hosting ? module.s3[0].bucket_name : null
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = var.enable_static_hosting ? module.cloudfront[0].distribution_domain_name : null
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = var.enable_static_hosting ? module.cloudfront[0].distribution_id : null
}

output "route53_name_servers" {
  description = "Route53 hosted zone name servers"
  value       = var.domain_name != null && var.create_hosted_zone ? module.route53[0].name_servers : null
}

output "alb_fqdn" {
  description = "Fully qualified domain name for ALB"
  value       = var.domain_name != null ? module.route53[0].alb_fqdn : null
}

output "cloudfront_fqdn" {
  description = "Fully qualified domain name for CloudFront CDN"
  value       = var.domain_name != null ? module.route53[0].cloudfront_fqdn : null
}
