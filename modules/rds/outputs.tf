############################################
# RDS Module - Outputs
############################################

output "rds_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.id
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}

output "secret_arn" {
  description = "ARN of the RDS password secret"
  value       = aws_secretsmanager_secret.rds_password.arn
}

output "secret_name" {
  description = "Name of the RDS password secret"
  value       = aws_secretsmanager_secret.rds_password.name
}

output "master_user_secret_arn" {
  description = "ARN of the master user secret managed by RDS"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}