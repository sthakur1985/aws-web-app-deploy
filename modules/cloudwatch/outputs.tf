##############################################
# CloudWatch Module - outputs.tf
##############################################

output "ec2_high_cpu_alarm_arn" {
  description = "ARN of the EC2 high CPU alarm"
  value       = try(aws_cloudwatch_metric_alarm.ec2_high_cpu[0].arn, null)
}

output "rds_low_storage_alarm_arn" {
  description = "ARN of the RDS low storage alarm"
  value       = try(aws_cloudwatch_metric_alarm.rds_low_storage[0].arn, null)
}

output "rds_high_cpu_alarm_arn" {
  description = "ARN of the RDS high CPU alarm"
  value       = try(aws_cloudwatch_metric_alarm.rds_high_cpu[0].arn, null)
}
