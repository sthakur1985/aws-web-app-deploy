# Route53 Module

## Overview
DNS management for custom domains with support for ALB and CloudFront alias records, hosted zone management.

## Architecture Decisions

### 🌐 Flexible DNS Management
**Decision**: Support both new and existing hosted zones
- **New Hosted Zone**: Create and manage DNS zone
- **Existing Zone**: Use pre-existing hosted zone
- **Conditional Creation**: Based on configuration

**Rationale**:
- Flexibility for different deployment scenarios
- Support for existing domain infrastructure
- Cost optimization (avoid duplicate zones)
- Migration-friendly approach

### 🎯 Alias Record Strategy
**Decision**: Use AWS alias records for AWS resources
- **ALB Records**: Point to load balancer
- **CloudFront Records**: Point to CDN distribution
- **Health Checks**: Automatic failover capability
- **No IP Dependencies**: Dynamic AWS resource mapping

**Rationale**:
- Better performance (no additional DNS lookup)
- Automatic IP address updates
- Health check integration
- Cost optimization (no charge for alias queries)

### 🏷️ Subdomain Organization
**Decision**: Configurable subdomain structure
- **ALB**: Configurable subdomain or apex domain
- **CloudFront**: Default 'cdn' subdomain
- **Flexibility**: Custom subdomain naming

**Rationale**:
- Clear service separation
- Flexible naming conventions
- Easy service identification
- Future expansion capability

### 🔒 Security Considerations
**Decision**: Health checks for high availability
- **ALB Health Checks**: Monitor application availability
- **Failover**: Automatic traffic routing
- **Monitoring**: DNS query monitoring

**Rationale**:
- High availability requirements
- Automatic disaster recovery
- User experience protection
- Service reliability

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| Hosted Zone | 0-1 | DNS zone management |
| A Record (ALB) | 0-1 | Application DNS |
| A Record (CloudFront) | 0-1 | CDN DNS |

## Key Variables

```hcl
# Domain Configuration
domain_name = "example.com"           # Primary domain
create_hosted_zone = false            # Create new zone?
hosted_zone_id = "Z123456789"         # Existing zone ID

# Subdomain Configuration
alb_subdomain = null                  # ALB subdomain (or apex)
cdn_subdomain = "cdn"                 # CDN subdomain

# AWS Resource Integration
alb_dns_name = "alb-123.elb.aws.com"           # ALB endpoint
cloudfront_domain_name = "d123.cloudfront.net"  # CDN endpoint
```

## DNS Record Types

### ALB A Record
- **Type**: Alias record
- **Target**: Application Load Balancer
- **Health Check**: Enabled for availability
- **Subdomain**: Configurable (default: apex domain)

### CloudFront A Record
- **Type**: Alias record
- **Target**: CloudFront distribution
- **Health Check**: Disabled (CDN handles availability)
- **Subdomain**: Configurable (default: 'cdn')

## Domain Configuration Examples

### Apex Domain Setup
```hcl
domain_name = "example.com"
alb_subdomain = null          # Results in: example.com
cdn_subdomain = "cdn"         # Results in: cdn.example.com
```

### Subdomain Setup
```hcl
domain_name = "example.com"
alb_subdomain = "app"         # Results in: app.example.com
cdn_subdomain = "static"      # Results in: static.example.com
```

## Hosted Zone Management

### New Hosted Zone
- **Creation**: Terraform manages the zone
- **Name Servers**: Output for domain registrar
- **Cost**: ~$0.50/month per zone
- **Management**: Full Terraform control

### Existing Hosted Zone
- **Reference**: Use existing zone ID
- **Records Only**: Only manage DNS records
- **Cost**: No additional zone charges
- **Integration**: Works with existing infrastructure

## Health Checks & Monitoring

- **ALB Health Checks**: Monitor application availability
- **Failover Routing**: Automatic traffic redirection
- **CloudWatch Integration**: DNS query metrics
- **Alarm Integration**: Notification on failures

## SSL Certificate Integration

- **ACM Integration**: Works with AWS Certificate Manager
- **Domain Validation**: DNS-based certificate validation
- **Wildcard Support**: Subdomain certificate coverage
- **Automatic Renewal**: ACM handles certificate lifecycle

## Cost Considerations

- **Hosted Zone**: $0.50/month per zone
- **DNS Queries**: $0.40 per million queries
- **Health Checks**: $0.50/month per health check
- **Alias Records**: No additional charge

## Integration Points

- **ALB**: Application load balancer DNS
- **CloudFront**: CDN distribution DNS
- **ACM**: SSL certificate validation
- **CloudWatch**: DNS monitoring metrics

## Best Practices Implemented

- **Alias Records**: Better performance and cost
- **Health Checks**: High availability
- **Subdomain Organization**: Clear service separation
- **Flexible Configuration**: Multiple deployment scenarios
- **Resource Tagging**: Complete metadata

## Outputs

- Hosted zone ID for external references
- Name servers for domain registrar configuration
- FQDN records for application access
- DNS endpoints for monitoring and testing