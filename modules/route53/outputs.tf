############################################
# Route53 Module - Outputs
############################################

output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
}

output "name_servers" {
  description = "Route53 hosted zone name servers"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "alb_fqdn" {
  description = "Fully qualified domain name for ALB"
  value       = var.alb_dns_name != null && var.domain_name != null ? aws_route53_record.alb[0].fqdn : null
}

output "cloudfront_fqdn" {
  description = "Fully qualified domain name for CloudFront"
  value       = var.cloudfront_domain_name != null && var.domain_name != null ? aws_route53_record.cloudfront[0].fqdn : null
}