# CloudFront Module

## Overview
Global CDN distribution for static content delivery with S3 origin, HTTPS enforcement, and custom domain support.

## Architecture Decisions

### 🌐 Global Content Delivery
**Decision**: CloudFront for worldwide content distribution
- **Edge Locations**: 400+ global edge locations
- **Performance**: Reduced latency for global users
- **Caching**: Intelligent content caching
- **Cost**: Reduced origin server load

**Rationale**:
- Improved user experience globally
- Reduced bandwidth costs
- Better application performance
- Scalability for traffic spikes

### 🔒 Security Configuration
**Decision**: HTTPS-only with modern security features
- **Viewer Protocol**: Redirect HTTP to HTTPS
- **SSL/TLS**: Modern cipher suites
- **Origin Access Control**: Secure S3 access
- **Custom Domains**: SSL certificate support

**Rationale**:
- Security best practices
- SEO benefits (HTTPS ranking factor)
- Browser security requirements
- Compliance standards

### 💰 Cost Optimization Strategy
**Decision**: Configurable price class
- **PriceClass_100**: US, Canada, Europe (cheapest)
- **PriceClass_200**: + Asia Pacific
- **PriceClass_All**: All edge locations (most expensive)

**Rationale**:
- Cost control for different environments
- Geographic targeting flexibility
- Budget optimization
- Performance vs cost balance

### 🎯 Caching Strategy
**Decision**: Optimized caching for static content
- **Default TTL**: 1 hour (3600 seconds)
- **Max TTL**: 24 hours (86400 seconds)
- **Compression**: Enabled for better performance
- **Methods**: Support for all HTTP methods

**Rationale**:
- Balance between freshness and performance
- Reduced origin requests
- Better user experience
- Bandwidth optimization

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| CloudFront Distribution | 1 | Global CDN |

## Key Variables

```hcl
# S3 Integration
s3_bucket_name           = "webapp-dev-static"  # Origin bucket
s3_bucket_domain_name    = "bucket.s3.region"  # Origin domain
origin_access_control_id = "oac-id"            # Security control

# Custom Domain (Optional)
domain_name         = null                      # Custom domain
ssl_certificate_arn = null                      # SSL certificate

# Performance
price_class = "PriceClass_100"                 # Cost optimization
```

## Security Features

- **HTTPS Enforcement**: Automatic HTTP to HTTPS redirect
- **Origin Access Control**: Modern S3 security model
- **SSL/TLS**: Strong encryption with custom certificates
- **Geo Restrictions**: Can be configured for compliance
- **Security Headers**: Custom headers support

## Performance Optimizations

- **Global Edge Network**: 400+ locations worldwide
- **HTTP/2**: Modern protocol support
- **Compression**: Automatic gzip compression
- **Caching**: Intelligent content caching
- **IPv6**: Full IPv6 support enabled

## Caching Configuration

```hcl
# Cache Behavior
default_cache_behavior {
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  compress               = true
  viewer_protocol_policy = "redirect-to-https"
  
  # TTL Settings
  min_ttl     = 0        # Minimum cache time
  default_ttl = 3600     # Default cache time (1 hour)
  max_ttl     = 86400    # Maximum cache time (24 hours)
}
```

## Cost Considerations

- **Price Classes**: Geographic distribution affects cost
- **Data Transfer**: Outbound data transfer charges
- **Requests**: Per-request pricing
- **SSL Certificates**: Custom SSL certificate costs

## Custom Domain Setup

1. **Certificate**: Create/import SSL certificate in ACM (us-east-1)
2. **Domain**: Configure custom domain in variables
3. **DNS**: Point domain to CloudFront distribution
4. **Validation**: Verify SSL certificate and domain

## Monitoring & Analytics

- **CloudWatch Metrics**: Request count, error rates, latency
- **Real-time Logs**: Detailed request logging (optional)
- **Cache Statistics**: Hit/miss ratios
- **Geographic Reports**: User location analytics

## Integration Points

- **S3**: Static content origin
- **Route53**: DNS alias records
- **ACM**: SSL certificate management
- **WAF**: Web application firewall (optional)
- **Lambda@Edge**: Edge computing (optional)

## Best Practices Implemented

- **HTTPS Only**: Security and SEO benefits
- **Compression**: Bandwidth optimization
- **Caching**: Performance optimization
- **Global Distribution**: User experience
- **Security**: Modern OAC implementation

## Outputs

- Distribution ID for management operations
- Distribution ARN for policy references
- Domain name for DNS configuration
- Hosted zone ID for Route53 records