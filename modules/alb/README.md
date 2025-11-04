# ALB Module

## Overview
Application Load Balancer for high availability web application traffic distribution with security features.

## Architecture Decisions

### 🔒 Security-First Design
**Decision**: HTTPS enforcement with optional SSL certificates
- **HTTP Listener**: Redirects to HTTPS when SSL cert provided
- **HTTPS Listener**: Only created when SSL certificate available
- **Security Headers**: Drop invalid headers enabled by default

**Rationale**:
- Security best practices
- Flexible deployment (dev without SSL, prod with SSL)
- Protection against header-based attacks

### 🌐 Multi-AZ Deployment
**Decision**: Deploy across multiple public subnets
- **Minimum**: 2 subnets in different AZs
- **Validation**: Enforced via variable validation

**Rationale**:
- High availability requirement
- AWS ALB best practices
- Fault tolerance across AZs

### 📊 Access Logging
**Decision**: Optional ALB access logs to S3
- **Configurable**: Enable/disable via variables
- **Validation**: S3 bucket required when enabled

**Rationale**:
- Compliance requirements
- Security analysis
- Performance monitoring
- Cost control (logs can be expensive)

### 🎯 Target Group Configuration
**Decision**: HTTP target group with health checks
- **Protocol**: HTTP (SSL termination at ALB)
- **Health Checks**: Comprehensive monitoring
- **Sticky Sessions**: Not enabled (stateless design)

**Rationale**:
- SSL termination reduces EC2 CPU load
- Better performance with HTTP backend
- Simplified certificate management

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| Application Load Balancer | 1 | Traffic distribution |
| Target Group | 1 | EC2 instance targets |
| Security Group | 1 | ALB access control |
| HTTP Listener | 1 | Port 80 handling |
| HTTPS Listener | 0-1 | Port 443 (if SSL cert) |

## Key Variables

```hcl
# SSL Configuration
ssl_certificate_arn = null  # Optional SSL certificate

# Security
allowed_cidr_blocks = ["0.0.0.0/0"]  # Access control
drop_invalid_header_fields = true     # Security headers

# Features
enable_deletion_protection = false    # Production safety
enable_access_logs = false           # Logging to S3
```

## Security Features

- **CIDR-based Access Control**: Configurable IP restrictions
- **Security Groups**: Least privilege access
- **SSL/TLS**: Modern cipher suites when enabled
- **Header Validation**: Protection against malformed requests
- **HTTPS Redirect**: Automatic HTTP to HTTPS redirection

## Performance Optimizations

- **HTTP/2**: Enabled by default
- **Connection Draining**: Graceful instance removal
- **Health Checks**: Fast failure detection
- **Cross-Zone Load Balancing**: Even traffic distribution

## Cost Considerations

- **ALB Pricing**: ~$16/month base + LCU charges
- **Data Transfer**: Cross-AZ costs
- **Access Logs**: S3 storage costs when enabled

## Integration Points

- **VPC**: Requires public subnets
- **Compute**: Target group for EC2 instances
- **Route53**: DNS alias records
- **CloudWatch**: Metrics and alarms

## Outputs

- ALB DNS name for application access
- Target group ARN for EC2 registration
- Security group ID for EC2 rules
- Zone ID for Route53 records