# 🚀 AWS Web App Deployment with Terraform & GitHub Actions

This repository automates the deployment and destruction of AWS infrastructure using Terraform and GitHub Actions. It supports multiple environments (`dev`, `staging`, `prod`) and regions, and integrates with Terraform Cloud for remote state management and speculative planning.

A comprehensive Terraform project for deploying a scalable, secure web application infrastructure on AWS with multi-environment support.

## 🏗️ Architecture Overview

Design Diagrams
(https://github.com/sthakur1985/aws-web-app-deploy/blob/main/aws-architecture-webapp-1.jpg)
(https://github.com/sthakur1985/aws-web-app-deploy/blob/main/aws-architecture-webapp-2.jpg)
This project creates a complete 3-tier web application infrastructure:

- **Presentation Tier**: Application Load Balancer (ALB) with SSL/TLS termination
- **Application Tier**: Auto Scaling Group with EC2 instances in private subnets
- **Data Tier**: RDS MySQL is deployed in Multi-Az mode. Diagram depicts provsion of read replica.
- **Content Delivery**: S3 + CloudFront for static content
- **DNS Management**: Route53 for domain management
- **Security**: Centralized IAM roles and security groups
- **Monitoring**: CloudWatch alarms and logging


## 📁 Project Structure

```
aws-web-app-deploy/
└── workflows/
    └── terraform.yml       # Github actions workflow
├── main.tf                 # Root module configuration
├── variables.tf            # Input variables
├── outputs.tf             # Output values
├── backend.tf             # Terraform backend configuration
├── environments/          # Environment-specific configurations
│   ├── dev/
│   │   ├── terraform.tfvars
│   │   ├── backend.hcl
│   │   └── secrets.tfvars.example
│   ├── staging/
│   └── prod/
└── modules/               # Reusable Terraform modules
    ├── vpc/              # VPC, subnets, routing
    ├── alb/              # Application Load Balancer
    ├── compute/          # EC2 Auto Scaling Group
    ├── rds/              # RDS database
    ├── iam/              # IAM roles and policies
    ├── s3/               # S3 bucket for static content
    ├── cloudfront/       # CloudFront CDN
    ├── route53/          # DNS management
    └── cloudwatch/       # Monitoring and alarms
```

## 🌐 Network Architecture

### Subnet Design
- **2 Public Subnets** (ALB) - Multi-AZ for high availability
- **2 EC2 Private Subnets** (Application servers) - Multi-AZ with NAT Gateway access
- **2 RDS Private Subnets** (Database) - Multi-AZ, isolated from internet

### Security Groups
- **ALB Security Group**: HTTP/HTTPS from internet
- **EC2 Security Group**: HTTP from ALB only
- **RDS Security Group**: Database port from EC2 only

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.5.0
- Provider Version ~> 5.0
- An AWS account with necessary permissions

### 1. Clone and Setup
```bash
git clone <repository-url>
cd aws-web-app-deploy
```

### 2. Configure Environment
```bash
# Copy and edit environment configuration
cp environments/dev/terraform.tfvars.example environments/dev/terraform.tfvars
cp environments/dev/secrets.tfvars.example environments/dev/secrets.tfvars

# Edit with your values
vi environments/dev/terraform.tfvars
vi environments/dev/secrets.tfvars  #  may not be used as we are using secrets from pipeline secret env variables. Can be used in user local unit testing.
```
## 🧰 Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads)
- [Terraform Cloud](https://app.terraform.io/)
- AWS account with access keys
- GitHub repository secrets configured:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `TF_API_TOKEN` (Terraform Cloud user token)
  - `TF_DB_CRED` (optional: database credentials or other sensitive vars)

---
### 3. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init -backend-config=environments/dev/backend.hcl

# Plan deployment
terraform plan -var-file=environments/dev/terraform.tfvars -var="<secret-key>=<secret-value>"

# Apply changes
terraform apply -var-file=environments/dev/terraform.tfvars -var="<secret-key>=<secret-value>"
```

## 🔧 Configuration

### Required Variables
```hcl
# Basic Configuration
aws_region   = "eu-west-2"
env          = "dev"
project      = "webapp"
project_name = "webapp"
costcenter   = "development"
owner        = "dev-team"

# Network Configuration
vpc_cidr                  = "10.0.0.0/16"
public_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
ec2_private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
rds_private_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]

# Compute Configuration
instance_type = "t3.micro"
key_name     = "my-keypair"

# Database Configuration
db_engine         = "mysql"
db_instance_class = "db.t3.micro"
db_name          = "appdb"
db_username      = "admin"
```

### Secrets Configuration
Create `environments/{env}/secrets.tfvars`:
```hcl
db_password = "your-secure-password-here"
```

## 🌍 Multi-Environment Support

### Environment Differences

| Feature | Dev | Staging | Production |
|---------|-----|---------|------------|
| Instance Type | t3.micro | t3.small | t3.medium |
| RDS Multi-AZ | No | Yes | Yes |
| Monitoring | Basic | Enhanced | Full |
| Backup Retention | 7 days | 14 days | 30 days |
| Auto Scaling | 1-2 instances | 1-3 instances | 2-10 instances |

### Deployment Commands

**Development:**
```bash
terraform init -backend-config=environments/dev/backend.hcl
terraform apply -var-file=environments/dev/terraform.tfvars -var="<secret-key>=<secret-value>"
```

**Staging:**
```bash
terraform init -backend-config=environments/staging/backend.hcl
terraform apply -var-file=environments/staging/terraform.tfvars -var="<secret-key>=<secret-value>"
```

**Production:**
```bash
terraform init -backend-config=environments/prod/backend.hcl
terraform apply -var-file=environments/prod/terraform.tfvars -var="<secret-key>=<secret-value>"
```

## 🔒 Security Features

### Infrastructure Security
- **VPC Flow Logs** for network monitoring
- **Private subnets** for application and database tiers
- **Security groups** with least privilege access
- **NAT Gateways** for secure outbound internet access
- **RDS encryption** at rest and in transit

### IAM Security
- **Centralized IAM module** for role management
- **EC2 instance profiles** with minimal permissions
- **RDS monitoring roles** for enhanced monitoring
- **Principle of least privilege** throughout

### Data Security
- **AWS Secrets Manager** for RDS password management
- **S3 bucket encryption** for static content
- **CloudFront HTTPS** enforcement
- **ALB SSL/TLS** termination

## 📊 Monitoring & Logging

### CloudWatch Alarms
- **EC2 CPU utilization** monitoring
- **RDS CPU and storage** monitoring
- **ALB response time** and error rate monitoring
- **Custom thresholds** per environment

### Logging
- **VPC Flow Logs** to CloudWatch
- **ALB access logs** to S3 (optional)
- **RDS logs** to CloudWatch (configurable)

## 🌐 CDN & DNS

### CloudFront Configuration
- **S3 origin** with Origin Access Control (OAC)
- **HTTPS redirect** enforcement
- **Compression** enabled
- **Custom domains** support with SSL certificates

### Route53 Integration
- **Hosted zone** management (optional)
- **A records** for ALB and CloudFront
- **Health checks** for high availability

## 🚨 Troubleshooting

### Common Issues

**ALB Creation Failed:**
- Check if your AWS account has ALB permissions
- Verify subnet configuration and availability zones

**RDS Connection Issues:**
- Verify security group rules
- Check subnet group configuration
- Ensure RDS is in private subnets

**Terraform State Issues:**
- Ensure S3 bucket exists for state storage
- Check backend configuration in `.hcl` files
- Verify AWS credentials and permissions

### Useful Commands
```bash
# Check Terraform state
terraform state list

# Import existing resources
terraform import aws_instance.example i-1234567890abcdef0

# Refresh state
terraform refresh

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive
```

## 📋 Outputs

After successful deployment, you'll receive:

```hcl
# Network Information
vpc_id                = "vpc-xxxxxxxxx"
public_subnet_ids     = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
private_subnet_ids    = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]

# Application Information
alb_dns_name         = "webapp-dev-alb-xxxxxxxxx.eu-west-2.elb.amazonaws.com"
cloudfront_domain    = "xxxxxxxxx.cloudfront.net"

# Database Information
rds_endpoint         = "webapp-dev-rds.xxxxxxxxx.eu-west-2.rds.amazonaws.com"

# DNS Information (if configured)
alb_fqdn            = "app.example.com"
cloudfront_fqdn     = "cdn.example.com"
```



---

## 📦 Features

- Modular Terraform setup for AWS resources (VPC, EC2, RDS, ALB, S3, CloudFront)
- GitHub Actions workflow for:
  - `terraform init`, `fmt`, `plan`, and `apply`
  - Environment and region selection
  - Secure secret management
- Supports both `terraform_apply` and `terraform_destroy` actions
- Uses s3 bucket and dynamodb for statefile management. ( for dev and staging s3 lockfile is enabled instead for dynamodb )

---

##  Testing ( Optional )

- Unit testing code using terratest and go.
- Integration test code will help to check the all modules are working as expected together.
- format and syntax checking.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review AWS documentation
3. Open an issue in the repository
4. Contact Soumya Thakur (soumyathakur85@gmail.com)

---

**Note:** Always review and test configurations in a development environment before applying to production. Ensure you understand the AWS costs associated with the resources created by this infrastructure.
