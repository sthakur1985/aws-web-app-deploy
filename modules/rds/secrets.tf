# AWS Secrets Manager for RDS password
resource "aws_secretsmanager_secret" "rds_password" {
  name                    = "${var.project}-rds-password"
  description             = "RDS database password for ${var.project}"
  recovery_window_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${var.project}-rds-password"
  })
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}