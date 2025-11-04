# CloudWatch Module

## Overview
Comprehensive monitoring and alerting for AWS infrastructure with customizable thresholds and notification integration.

## Architecture Decisions

### 📊 Multi-Service Monitoring
**Decision**: Centralized monitoring for all infrastructure components
- **EC2 Monitoring**: CPU utilization and instance health
- **RDS Monitoring**: Database performance and storage
- **ALB Monitoring**: Load balancer performance and errors
- **Unified Alerting**: Consistent notification strategy

**Rationale**:
- Comprehensive infrastructure visibility
- Proactive issue detection
- Centralized alert management
- Operational efficiency

### 🚨 Configurable Alert Thresholds
**Decision**: Environment-specific monitoring thresholds
- **Development**: Higher thresholds, fewer alerts
- **Production**: Lower thresholds, comprehensive monitoring
- **Customizable**: Per-metric threshold configuration
- **Scalable**: Easy threshold adjustments

**Rationale**:
- Environment-appropriate monitoring
- Reduced alert fatigue in development
- Critical monitoring in production
- Operational flexibility

### 🔔 Optional Notification Integration
**Decision**: Configurable SNS topic integration
- **SNS Topics**: External notification system
- **Multiple Channels**: Email, SMS, webhooks
- **Environment-Specific**: Different notification strategies
- **Cost Control**: Optional notification to manage costs

**Rationale**:
- Flexible notification options
- Integration with existing systems
- Cost optimization
- Operational preferences

### 📈 Performance-Focused Metrics
**Decision**: Key performance indicators for each service
- **Response Time**: Application performance monitoring
- **Error Rates**: Service reliability tracking
- **Resource Utilization**: Capacity planning metrics
- **Health Status**: Service availability monitoring

**Rationale**:
- Focus on business-critical metrics
- Proactive capacity planning
- Service reliability assurance
- Performance optimization

## Resources Created

| Resource | Count | Purpose |
|----------|-------|---------|
| EC2 CPU Alarm | 1 | Instance performance |
| RDS CPU Alarm | 1 | Database performance |
| RDS Storage Alarm | 1 | Storage capacity |
| ALB Response Time Alarm | 0-1 | Application performance |
| ALB Unhealthy Hosts Alarm | 0-1 | Service availability |
| ALB 5XX Error Alarm | 0-1 | Error rate monitoring |

## Key Variables

```hcl
# Monitoring Configuration
enable_alb_alarms = true              # ALB monitoring
alarm_actions = ["arn:aws:sns:..."]   # Notification topics

# Threshold Configuration
ec2_cpu_threshold = 80                # EC2 CPU percentage
rds_cpu_threshold = 80                # RDS CPU percentage
rds_free_storage_threshold = 2000000000  # RDS storage bytes

# Resource Integration
asg_name = "webapp-dev-asg"           # Auto Scaling Group
db_instance_identifier = "webapp-rds" # RDS instance
alb_arn = "arn:aws:elasticloadbalancing:..." # Load balancer
```

## Monitoring Metrics

### EC2 Monitoring
- **CPU Utilization**: Average CPU usage across ASG
- **Threshold**: Configurable (default: 80%)
- **Period**: 5-minute evaluation
- **Action**: Scale-out trigger potential

### RDS Monitoring
- **CPU Utilization**: Database server performance
- **Free Storage Space**: Available disk space
- **Thresholds**: Configurable per environment
- **Period**: 5-minute evaluation

### ALB Monitoring (Optional)
- **Target Response Time**: Application performance
- **Unhealthy Host Count**: Service availability
- **HTTP 5XX Errors**: Error rate tracking
- **Period**: 5-minute evaluation

## Alert Configuration

### Evaluation Periods
- **Standard**: 2 consecutive periods
- **Sensitivity**: Balance between responsiveness and false positives
- **Customizable**: Can be adjusted per alarm

### Notification Actions
- **Alarm State**: Triggered when threshold exceeded
- **OK State**: Triggered when returning to normal
- **Insufficient Data**: Handled gracefully

## Cost Optimization

- **Metric Charges**: $0.30 per metric per month
- **Alarm Charges**: $0.10 per alarm per month
- **SNS Charges**: Per notification delivery
- **Optional Features**: Disable unused monitoring

## Integration Points

- **Auto Scaling**: CPU alarms can trigger scaling
- **SNS**: Notification delivery
- **Lambda**: Custom alert processing
- **PagerDuty**: External incident management

## Environment-Specific Configuration

### Development
```hcl
enable_alb_alarms = false     # Reduced monitoring
ec2_cpu_threshold = 90        # Higher threshold
alarm_actions = []            # No notifications
```

### Production
```hcl
enable_alb_alarms = true      # Full monitoring
ec2_cpu_threshold = 70        # Lower threshold
alarm_actions = ["sns-arn"]   # Active notifications
```

## Best Practices Implemented

- **Meaningful Metrics**: Focus on business impact
- **Appropriate Thresholds**: Environment-specific values
- **Consistent Naming**: Clear alarm identification
- **Resource Tagging**: Complete metadata
- **Cost Awareness**: Optional features for cost control

## Monitoring Dashboard

Recommended CloudWatch dashboard widgets:
- EC2 CPU utilization trends
- RDS performance metrics
- ALB request and error rates
- Auto Scaling Group capacity
- Cost and billing metrics

## Outputs

- Alarm ARNs for external integration
- Metric names for custom dashboards
- SNS topic references
- CloudWatch log group information