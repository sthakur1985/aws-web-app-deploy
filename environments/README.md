# Environment-Specific Configurations

This directory contains environment-specific configurations for dev, staging, and prod environments.

## Usage

### Development Environment
```bash
# Initialize
terraform init -backend-config=environments/dev/backend.hcl

# Plan
terraform plan -var-file=environments/dev/terraform.tfvars

# Apply
terraform apply -var-file=environments/dev/terraform.tfvars
```

### Staging Environment
```bash
# Initialize
terraform init -backend-config=environments/staging/backend.hcl

# Plan
terraform plan -var-file=environments/staging/terraform.tfvars

# Apply
terraform apply -var-file=environments/staging/terraform.tfvars
```

### Production Environment
```bash
# Initialize
terraform init -backend-config=environments/prod/backend.hcl

# Plan
terraform plan -var-file=environments/prod/terraform.tfvars

# Apply
terraform apply -var-file=environments/prod/terraform.tfvars
```

## Environment Differences

### Dev
- Minimal resources for cost optimization
- Single AZ deployment
- No monitoring alarms
- t3.micro instances

### Staging
- Production-like setup for testing
- Multi-AZ RDS
- Enhanced monitoring
- t3.small instances

### Production
- High availability and performance
- Full monitoring and alerting
- Backup retention: 30 days
- t3.medium instances
- CloudFront global distribution