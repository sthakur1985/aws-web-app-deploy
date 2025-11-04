# Compute Module

## Overview
Auto Scaling Group with EC2 instances for scalable web application hosting using launch templates.

## Architecture Decisions

### 🚀 Auto Scaling Strategy
**Decision**: Auto Scaling Group with configurable capacity
- **Min/Max/Desired**: Environment-specific scaling
- **Health Checks**: EC2 and ELB health monitoring
- **Launch Template**: Versioned instance configuration

**Rationale**:
- Automatic scaling based on demand
- High availability across AZs
- Cost optimization through right-sizing
- Blue-green deployment capability

### 🔒 Security Configuration
**Decision**: Private subnet deployment with IAM roles
- **Network**: No public IP addresses
- **IAM**: Centralized role management via IAM module
- **Security Groups**: Least privilege access

**Rationale**:
- Enhanced security posture
- Compliance with security frameworks
- Centralized permission management
- Network isolation

### 💾 Instance Configuration
**Decision**: Amazon Linux 2 with user data automation
- **AMI**: Latest Amazon Linux 2 (automatic selection)
- **User Data**: Nginx installation and configuration
- **Instance Profile**: SSM access for management

**Rationale**:
- Consistent, repeatable deployments
- Automated application setup
- Remote management capabilities
- Cost-effective instance types

### 🎯 Load Balancer Integration
**Decision**: Optional ALB target group registration
- **Automatic Registration**: ASG manages target registration
- **Health Checks**: Application-level monitoring
- **Graceful Scaling**: Connection draining

**Rationale**:
- Seamless traffic distribution
- Automatic failover capabilities
- Zero-downtime deployments

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| Auto Scaling Group | 1 | Instance management |
| Launch Template | 1 | Instance configuration |
| Security Group | 1 | Network access control |

## Key Variables

```hcl
# Scaling Configuration
asg_min_size         = 1      # Minimum instances
asg_max_size         = 2      # Maximum instances  
asg_desired_capacity = 1      # Target instances

# Instance Configuration
instance_type = "t3.micro"    # Instance size
key_name     = "my-keypair"   # SSH access

# Integration
alb_target_group_arn = null   # Optional ALB integration
```

## Security Features

- **Private Subnets**: No direct internet access
- **Security Groups**: Port 80 from ALB only
- **IAM Roles**: Minimal required permissions
- **SSH Access**: Key-based authentication
- **Systems Manager**: Secure remote access

## Scaling Behavior

- **Scale Out**: Add instances during high load
- **Scale In**: Remove instances during low load
- **Health Checks**: Replace unhealthy instances
- **AZ Distribution**: Even distribution across zones

## User Data Script

```bash
#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Hello from Terraform</h1>" > /usr/share/nginx/html/index.html
```

## Cost Optimization

- **Instance Types**: Right-sized for workload
- **Spot Instances**: Can be configured for cost savings
- **Auto Scaling**: Automatic capacity adjustment
- **Reserved Instances**: Long-term cost reduction

## Monitoring Integration

- **CloudWatch**: Instance metrics
- **ALB Health Checks**: Application monitoring
- **Systems Manager**: Patch compliance
- **Custom Metrics**: Application-specific monitoring

## Outputs

- Auto Scaling Group name for monitoring
- Security Group ID for database access
- Launch template ID for updates