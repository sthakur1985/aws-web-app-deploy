# Development Environment Configuration
aws_region   = "eu-west-2"
env          = "dev"
project      = "webapp"
project_name = "webapp"
costcenter   = "development"
owner        = "dev-team"

# VPC Configuration
vpc_cidr                 = "10.0.0.0/16"
public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
ec2_private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
rds_private_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
enable_nat_gateway       = true
enable_flow_logs         = false

# Compute Configuration
instance_type        = "t3.micro"
key_name             = "dev-keypair"
asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1

# RDS Configuration
db_engine               = "mysql"
db_instance_class       = "db.t3.micro"
db_allocated_storage    = 20
db_name                 = "devdb"
db_username             = "admin"
rds_multi_az            = false
rds_deletion_protection = false

# Static Content
enable_static_hosting  = true
cloudfront_price_class = "PriceClass_100"

# DNS (optional)
domain_name        = null
create_hosted_zone = false

# Monitoring
enable_alb_alarms = false
alarm_actions     = []