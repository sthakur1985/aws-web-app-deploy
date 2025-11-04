# VPC Module

## Overview
Creates a secure, multi-tier VPC with separate subnets for different application layers.

## Architecture Decisions

### 🏗️ Subnet Design
**Decision**: Separate EC2 and RDS into different private subnets
- **EC2 Private Subnets**: Application tier with NAT Gateway access
- **RDS Private Subnets**: Database tier with no internet access
- **Public Subnets**: Load balancer tier

**Rationale**:
- Enhanced security through network isolation
- Compliance with security best practices
- Easier network ACL management
- Clear separation of concerns

### 🌐 Multi-AZ Strategy
**Decision**: Deploy across 2 Availability Zones minimum
- **Public**: 2 subnets across 2 AZs
- **EC2 Private**: 2 subnets across 2 AZs  
- **RDS Private**: 2 subnets across 2 AZs

**Rationale**:
- High availability and fault tolerance
- AWS RDS requirement for Multi-AZ
- Load balancer best practices
- Disaster recovery capabilities

### 🔒 NAT Gateway Configuration
**Decision**: Multiple NAT Gateways (one per AZ)
- **High Availability**: Each AZ has its own NAT Gateway
- **Cost vs Availability**: Configurable via `enable_nat_gateway`

**Rationale**:
- Eliminates single point of failure
- Better performance distribution
- Reduced cross-AZ data transfer costs

### 📊 Flow Logs
**Decision**: Optional VPC Flow Logs to CloudWatch
- **Monitoring**: Network traffic analysis
- **Security**: Intrusion detection
- **Compliance**: Audit trail

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| VPC | 1 | Main network container |
| Internet Gateway | 1 | Internet access |
| Public Subnets | 2 | ALB placement |
| EC2 Private Subnets | 2 | Application servers |
| RDS Private Subnets | 2 | Database isolation |
| NAT Gateways | 2 | Outbound internet for EC2 |
| Route Tables | 5 | Traffic routing |
| Elastic IPs | 2 | NAT Gateway addresses |

## Key Variables

```hcl
# Network Configuration
vpc_cidr                  = "10.0.0.0/16"
public_subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
ec2_private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
rds_private_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]

# Features
enable_nat_gateway = true    # High availability vs cost
enable_flow_logs   = true    # Security monitoring
```

## Security Considerations

- **DNS Resolution**: Enabled for service discovery
- **Network Isolation**: RDS subnets have no internet routes
- **Least Privilege**: Security groups control access between tiers
- **Monitoring**: Flow logs for security analysis

## Cost Optimization

- **NAT Gateways**: Major cost component (~$45/month each)
- **Flow Logs**: CloudWatch storage costs
- **Data Transfer**: Cross-AZ charges for NAT Gateway traffic

## Outputs

- VPC and subnet IDs for other modules
- Route table IDs for custom routing
- Availability zones for resource placement
- Backward compatibility with `private_subnet_ids`