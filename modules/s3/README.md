# S3 Module

## Overview
Secure S3 bucket for static content hosting with encryption, versioning, and CloudFront integration.

## Architecture Decisions

### 🔒 Security-First Configuration
**Decision**: Block all public access by default
- **Public Access Block**: All public access disabled
- **Bucket Policy**: CloudFront access only via OAC
- **Encryption**: AES-256 server-side encryption

**Rationale**:
- Security best practices
- Compliance requirements
- Protection against data leaks
- Controlled access via CloudFront

### 📦 Versioning Strategy
**Decision**: Enable S3 versioning
- **Version Control**: Track content changes
- **Rollback Capability**: Restore previous versions
- **Accidental Deletion Protection**: Recover deleted objects

**Rationale**:
- Content management safety
- Deployment rollback capability
- Compliance requirements
- Operational safety net

### 🌐 CloudFront Integration
**Decision**: Origin Access Control (OAC) for CloudFront
- **Modern Security**: OAC instead of legacy OAI
- **Bucket Policy**: Service principal access only
- **No Direct Access**: All access via CloudFront

**Rationale**:
- Enhanced security model
- Better performance
- Global content delivery
- Cost optimization (CloudFront caching)

### 🏷️ Resource Naming
**Decision**: Environment-specific bucket naming
- **Pattern**: `{project}-{env}-static-content`
- **Uniqueness**: Global S3 namespace compliance
- **Identification**: Clear resource purpose

**Rationale**:
- Environment isolation
- Easy identification
- Automated management
- Cost allocation

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| S3 Bucket | 1 | Static content storage |
| Public Access Block | 1 | Security configuration |
| Bucket Versioning | 1 | Version control |
| Encryption Configuration | 1 | Data protection |
| Origin Access Control | 1 | CloudFront integration |

## Key Variables

```hcl
# Basic Configuration
project_name = "webapp"           # Bucket naming
env         = "dev"              # Environment
costcenter  = "development"      # Cost allocation
```

## Security Features

- **Public Access Block**: Prevents accidental public exposure
- **Server-Side Encryption**: AES-256 encryption at rest
- **Origin Access Control**: Modern CloudFront security
- **Bucket Policy**: Service principal access only
- **Versioning**: Protection against accidental changes

## Storage Configuration

- **Storage Class**: Standard (can be optimized with lifecycle)
- **Versioning**: Enabled for content management
- **Encryption**: Server-side with S3 managed keys
- **Access Logging**: Can be enabled for audit trails

## CloudFront Integration

- **Origin Access Control**: Secure CloudFront access
- **Bucket Policy**: Restricts access to CloudFront service
- **No Public Access**: All content served via CDN
- **Performance**: Global edge locations

## Cost Optimization

- **Lifecycle Policies**: Can transition to cheaper storage classes
- **Versioning**: Monitor version accumulation
- **CloudFront**: Reduces S3 request costs
- **Compression**: Reduces storage and transfer costs

## Content Management

- **Static Assets**: HTML, CSS, JavaScript, images
- **Deployment**: CI/CD pipeline integration
- **Versioning**: Rollback capabilities
- **Cache Control**: CloudFront cache headers

## Monitoring & Logging

- **CloudWatch Metrics**: Storage and request metrics
- **Access Logging**: Optional S3 access logs
- **CloudTrail**: API call logging
- **Cost Monitoring**: Storage and request costs

## Integration Points

- **CloudFront**: CDN distribution origin
- **CI/CD Pipeline**: Content deployment
- **Application**: Static asset serving
- **Monitoring**: CloudWatch metrics

## Best Practices Implemented

- **Security**: No public access, encryption enabled
- **Versioning**: Content change tracking
- **Naming**: Consistent, environment-specific
- **Integration**: Modern CloudFront security (OAC)
- **Tagging**: Complete resource metadata

## Outputs

- Bucket name for CloudFront configuration
- Bucket ARN for policy references
- Domain name for direct access (if needed)
- OAC ID for CloudFront distribution