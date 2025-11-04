# RDS Module

## Overview
Managed MySQL/PostgreSQL database with security, backup, and monitoring features for production workloads.

## Architecture Decisions

### 🔒 Security-First Database Design
**Decision**: AWS Secrets Manager for password management
- **Managed Passwords**: AWS-generated and rotated
- **Encryption**: At rest and in transit
- **Network Isolation**: Private subnets only

**Rationale**:
- Eliminates hardcoded passwords
- Automatic password rotation
- Compliance with security standards
- Reduced operational overhead

### 🏗️ High Availability Strategy
**Decision**: Configurable Multi-AZ deployment
- **Multi-AZ**: Environment-specific (dev: single, prod: multi)
- **Subnet Groups**: Spans multiple AZs
- **Backup Strategy**: Automated backups with retention

**Rationale**:
- Cost optimization for development
- High availability for production
- Disaster recovery capabilities
- Point-in-time recovery

### 📊 Monitoring & Performance
**Decision**: Optional enhanced monitoring and Performance Insights
- **Enhanced Monitoring**: 1-minute granularity
- **Performance Insights**: Query-level analysis
- **CloudWatch Logs**: Configurable log exports

**Rationale**:
- Performance troubleshooting
- Capacity planning
- Security monitoring
- Cost control (monitoring has charges)

### 🔐 Network Security
**Decision**: Dedicated RDS private subnets
- **Isolation**: Separate from EC2 subnets
- **Security Groups**: Database port from EC2 only
- **No Internet**: No NAT Gateway access

**Rationale**:
- Defense in depth security
- Compliance requirements
- Network segmentation
- Reduced attack surface

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| RDS Instance | 1 | Database server |
| DB Subnet Group | 1 | Multi-AZ placement |
| Security Group | 1 | Network access control |
| Secrets Manager Secret | 1 | Password storage |
| CloudWatch Alarms | 0-1 | Storage monitoring |

## Key Variables

```hcl
# Database Configuration
engine            = "mysql"        # Database engine
instance_class    = "db.t3.micro"  # Instance size
allocated_storage = 20             # Initial storage (GB)

# High Availability
multi_az = false                   # Multi-AZ deployment
backup_retention_period = 7        # Backup retention days

# Security
deletion_protection = true         # Accidental deletion protection
storage_encrypted = true           # Encryption at rest

# Monitoring
monitoring_interval = 0            # Enhanced monitoring (0=disabled)
performance_insights_enabled = false  # Performance analysis
```

## Security Features

- **Encryption**: AES-256 encryption at rest
- **TLS**: Encrypted connections in transit
- **Secrets Manager**: Secure password storage
- **Network ACLs**: Subnet-level protection
- **Security Groups**: Port-level access control
- **Deletion Protection**: Prevents accidental deletion

## Backup & Recovery

- **Automated Backups**: Daily snapshots
- **Point-in-Time Recovery**: Up to retention period
- **Manual Snapshots**: On-demand backups
- **Cross-Region**: Can be configured for DR

## Performance Optimization

- **Storage Type**: GP3 for better performance/cost
- **Auto Scaling**: Storage auto-scaling enabled
- **Parameter Groups**: Custom database tuning
- **Connection Pooling**: Application-level optimization

## Cost Management

- **Instance Sizing**: Right-sized for workload
- **Storage**: Auto-scaling prevents over-provisioning
- **Backup Retention**: Balanced retention vs cost
- **Reserved Instances**: Long-term cost savings

## Monitoring Capabilities

- **CloudWatch Metrics**: CPU, memory, connections
- **Enhanced Monitoring**: OS-level metrics
- **Performance Insights**: Query performance
- **Slow Query Logs**: Performance troubleshooting
- **Error Logs**: Issue identification

## Integration Points

- **VPC**: Requires RDS private subnets
- **Compute**: Security group access from EC2
- **IAM**: Optional monitoring role
- **CloudWatch**: Metrics and alarms
- **Secrets Manager**: Password retrieval

## Outputs

- RDS endpoint for application connection
- Security group ID for access rules
- Secret ARN for password retrieval
- Instance identifier for monitoring