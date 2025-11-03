# ALB CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  count               = var.enable_alb_alarms ? 1 : 0
  alarm_name          = "${var.project}-alb-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = var.alb_response_time_threshold
  alarm_description   = "ALB target response time is too high"

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  count               = var.enable_alb_alarms ? 1 : 0
  alarm_name          = "${var.project}-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "ALB has unhealthy targets"

  dimensions = {
    TargetGroup  = var.target_group_arn
    LoadBalancer = var.alb_arn
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  count               = var.enable_alb_alarms ? 1 : 0
  alarm_name          = "${var.project}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  alarm_description   = "ALB 5XX error rate is too high"

  dimensions = {
    LoadBalancer = var.alb_arn
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}