# IAM Module

## Overview
Centralized IAM role and policy management following the principle of least privilege for secure AWS resource access.

## Architecture Decisions

### 🔒 Centralized IAM Management
**Decision**: Single module for all IAM resources
- **Consolidation**: All roles and policies in one place
- **Consistency**: Standardized naming and tagging
- **Governance**: Easier security auditing

**Rationale**:
- Simplified security management
- Reduced code duplication
- Better compliance tracking
- Centralized permission control

### 🛡️ Least Privilege Principle
**Decision**: Minimal required permissions per service
- **EC2 Role**: SSM access only (no S3, no admin)
- **RDS Monitoring**: Enhanced monitoring permissions only
- **Service-Specific**: Tailored to actual needs

**Rationale**:
- Security best practices
- Compliance requirements
- Reduced blast radius
- Easier permission auditing

### 🔄 Conditional Resource Creation
**Decision**: Create resources only when needed
- **RDS Monitoring Role**: Only if monitoring enabled
- **Environment-Specific**: Different roles per environment
- **Feature Flags**: Enable/disable based on requirements

**Rationale**:
- Cost optimization
- Reduced complexity
- Environment-appropriate permissions
- Cleaner resource management

### 📋 Standardized Naming
**Decision**: Consistent naming convention
- **Pattern**: `{project}-{env}-{service}-{type}`
- **Example**: `webapp-dev-ec2-role`
- **Tagging**: Comprehensive resource tagging

**Rationale**:
- Easy identification
- Automated management
- Cost allocation
- Compliance reporting

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| EC2 IAM Role | 1 | EC2 service permissions |
| EC2 Instance Profile | 1 | EC2 role attachment |
| RDS Monitoring Role | 0-1 | Enhanced monitoring |
| Policy Attachments | 1-2 | AWS managed policies |

## Key Variables

```hcl
# Basic Configuration
project_name = "webapp"           # Resource naming
env         = "dev"              # Environment
costcenter  = "development"      # Cost allocation

# Feature Flags
enable_rds_monitoring = false    # RDS monitoring role
```

## IAM Roles & Policies

### EC2 Role
- **Purpose**: EC2 instance permissions
- **Policies**: `AmazonSSMManagedInstanceCore`
- **Capabilities**:
  - Systems Manager access
  - CloudWatch agent
  - Patch management
  - Session Manager

### RDS Monitoring Role (Optional)
- **Purpose**: Enhanced RDS monitoring
- **Policies**: `AmazonRDSEnhancedMonitoringRole`
- **Capabilities**:
  - OS-level metrics collection
  - CloudWatch metric publishing
  - Performance monitoring

## Security Features

- **Assume Role Policies**: Service-specific trust relationships
- **Managed Policies**: AWS-maintained, regularly updated
- **No Inline Policies**: Easier management and auditing
- **Resource Tagging**: Complete metadata for governance

## Best Practices Implemented

- **Principle of Least Privilege**: Minimal required permissions
- **Service Roles**: Dedicated roles per service
- **Managed Policies**: AWS-maintained security updates
- **Conditional Creation**: Resources only when needed
- **Comprehensive Tagging**: Full metadata tracking

## Compliance Considerations

- **SOC 2**: Role-based access control
- **PCI DSS**: Least privilege access
- **GDPR**: Data access controls
- **HIPAA**: Administrative safeguards

## Integration Points

- **Compute Module**: EC2 instance profile
- **RDS Module**: Optional monitoring role
- **CloudWatch**: Metrics and logging permissions
- **Systems Manager**: Instance management

## Monitoring & Auditing

- **CloudTrail**: API call logging
- **Access Analyzer**: Permission analysis
- **IAM Credential Report**: Access key usage
- **Resource Tags**: Cost and compliance tracking

## Outputs

- EC2 role name and ARN for compute module
- Instance profile name for EC2 attachment
- RDS monitoring role ARN (if enabled)
- Role identifiers for external references