############################################
# Route53 Module - DNS Management
############################################

# Route53 Hosted Zone (optional - only if domain_name is provided)
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name

  tags = {
    Name        = "${var.project_name}-${var.env}-zone"
    Environment = var.env
    Project     = var.project_name
    Owner       = var.costcenter
  }
}

# A record for ALB
resource "aws_route53_record" "alb" {
  count   = var.alb_dns_name != null && var.domain_name != null ? 1 : 0
  zone_id = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
  name    = var.alb_subdomain != null ? "${var.alb_subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# A record for CloudFront
resource "aws_route53_record" "cloudfront" {
  count   = var.cloudfront_domain_name != null && var.domain_name != null ? 1 : 0
  zone_id = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id
  name    = var.cdn_subdomain != null ? "${var.cdn_subdomain}.${var.domain_name}" : "cdn.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}