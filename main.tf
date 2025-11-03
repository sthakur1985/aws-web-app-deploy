############################################
# Root Module 
############################################
# IAM Module - Centralized IAM Resources
############################################
module "iam" {
  source = "./modules/iam"

  project_name          = var.project_name
  env                   = var.env
  costcenter            = var.costcenter
  enable_rds_monitoring = var.rds_monitoring_interval > 0
}

############################################
# Networking - VPC Module
############################################
module "vpc" {
  source = "./modules/vpc"

  project                 = var.project
  env                     = var.env
  costcenter              = var.costcenter
  enable_nat_gateway      = var.enable_nat_gateway
  enable_flow_logs        = var.enable_flow_logs
  flow_log_retention_days = var.flow_log_retention_days

  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  ec2_private_subnet_cidrs = var.ec2_private_subnet_cidrs
  rds_private_subnet_cidrs = var.rds_private_subnet_cidrs
}

############################################
# Load Balancer (ALB) Module
############################################
module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  project_name               = var.project_name
  env                        = var.env
  costcenter                 = var.costcenter
  ssl_certificate_arn        = var.ssl_certificate_arn
  enable_deletion_protection = var.enable_alb_deletion_protection
  enable_access_logs         = var.enable_alb_access_logs
  access_logs_bucket         = var.alb_access_logs_bucket
}

############################################
# Compute - EC2 Auto Scaling Module
############################################
module "compute" {
  source = "./modules/compute"

  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.ec2_private_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn

  project                   = var.project
  env                       = var.env
  costcenter                = var.costcenter
  aws_region                = var.aws_region
  owner                     = var.owner
  user_data_path            = var.user_data_path
  ec2_instance_profile_name = module.iam.ec2_instance_profile_name

  instance_type = var.instance_type
  key_name      = var.key_name

  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
}

############################################
# Database (RDS) Module
############################################
module "rds" {
  source = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.rds_private_subnet_ids
  ec2_security_group_id = module.compute.ec2_security_group_id

  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  project                         = var.project
  monitoring_interval             = var.rds_monitoring_interval
  performance_insights_enabled    = var.rds_performance_insights_enabled
  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports
  backup_retention_period         = var.rds_backup_retention_period
  multi_az                        = var.rds_multi_az
  deletion_protection             = var.rds_deletion_protection
  rds_monitoring_role_arn         = module.iam.rds_monitoring_role_arn
}

############################################
# S3 Module - Static Content Storage
############################################
module "s3" {
  count  = var.enable_static_hosting ? 1 : 0
  source = "./modules/s3"

  project_name = var.project_name
  env          = var.env
  costcenter   = var.costcenter
}

############################################
# CloudFront Module - CDN
############################################
module "cloudfront" {
  count  = var.enable_static_hosting ? 1 : 0
  source = "./modules/cloudfront"

  project_name             = var.project_name
  env                      = var.env
  costcenter               = var.costcenter
  s3_bucket_name           = module.s3[0].bucket_name
  s3_bucket_domain_name    = module.s3[0].bucket_domain_name
  origin_access_control_id = module.s3[0].origin_access_control_id
  domain_name              = var.domain_name
  ssl_certificate_arn      = var.ssl_certificate_arn
  price_class              = var.cloudfront_price_class
}

############################################
# S3 Bucket Policy for CloudFront Access
############################################
resource "aws_s3_bucket_policy" "cloudfront_access" {
  count  = var.enable_static_hosting ? 1 : 0
  bucket = module.s3[0].bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3[0].bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront[0].distribution_arn
          }
        }
      }
    ]
  })

  depends_on = [module.s3, module.cloudfront]
}

############################################
# Route53 Module - DNS Management
############################################
module "route53" {
  count  = var.domain_name != null ? 1 : 0
  source = "./modules/route53"

  project_name              = var.project_name
  env                       = var.env
  costcenter                = var.costcenter
  domain_name               = var.domain_name
  create_hosted_zone        = var.create_hosted_zone
  hosted_zone_id            = var.hosted_zone_id
  alb_dns_name              = module.alb.alb_dns_name
  alb_zone_id               = module.alb.alb_zone_id
  alb_subdomain             = var.alb_subdomain
  cloudfront_domain_name    = var.enable_static_hosting ? module.cloudfront[0].distribution_domain_name : null
  cloudfront_hosted_zone_id = var.enable_static_hosting ? module.cloudfront[0].distribution_hosted_zone_id : null
  cdn_subdomain             = var.cdn_subdomain
}

############################################
# CloudWatch Alarms (Optional)
############################################
module "cloudwatch" {
  source = "./modules/cloudwatch"

  asg_name               = module.compute.asg_name
  db_instance_identifier = module.rds.rds_instance_id

  project                    = var.project
  enable_alb_alarms          = var.enable_alb_alarms
  alb_arn                    = module.alb.alb_arn
  target_group_arn           = module.alb.target_group_arn
  alarm_actions              = var.alarm_actions
  ec2_cpu_threshold          = var.ec2_cpu_threshold
  rds_cpu_threshold          = var.rds_cpu_threshold
  rds_free_storage_threshold = var.rds_free_storage_threshold
}

