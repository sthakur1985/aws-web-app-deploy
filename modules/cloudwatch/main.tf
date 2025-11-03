##############################################
# CloudWatch Module - main.tf
##############################################

# ==============================
# EC2/ASG High CPU Alarm
# ==============================
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  count = var.enable_ec2_alarms && var.asg_name != "" ? 1 : 0

  alarm_name          = "${var.project}-ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.ec2_cpu_threshold
  alarm_description   = "EC2 CPU utilization exceeds ${var.ec2_cpu_threshold}% threshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}

# ==============================
# RDS Low Storage Alarm
# ==============================
resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  count               = var.enable_rds_alarms ? 1 : 0
  alarm_name          = "${var.project}-rds-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_free_storage_threshold
  alarm_description   = "Triggers if RDS free storage space < threshold"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}

# ==============================
# RDS High CPU Alarm
# ==============================
resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  count               = var.enable_rds_alarms ? 1 : 0
  alarm_name          = "${var.project}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_cpu_threshold
  alarm_description   = "Triggers if RDS CPU exceeds ${var.rds_cpu_threshold}%"
  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }
  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}
