##############################################
# RDS Module - main.tf
##############################################

resource "aws_db_subnet_group" "rds-sub" {
  name       = "${var.project}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(local.common_tags, {
    Name = "${var.project}-rds-subnet-group"
  })
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project}-rds-sg"
  description = "Allow DB access only from EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
    description     = "Allow DB access from EC2 SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-rds-sg"
  })
}

resource "aws_db_instance" "this" {
  identifier                      = "${var.project}-rds"
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  storage_type                    = var.storage_type
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_subnet_group_name            = aws_db_subnet_group.rds-sub.name
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  db_name                         = var.db_name
  username                        = var.username
  manage_master_user_password     = true
  master_user_secret_kms_key_id   = var.kms_key_id
  port                            = var.port
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot == true ? null : "${var.project}-rds-final-snapshot"
  publicly_accessible             = false
  multi_az                        = var.multi_az
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_id
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  auto_minor_version_upgrade      = true
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? var.rds_monitoring_role_arn : null
  performance_insights_enabled    = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = merge(local.common_tags, {
    Name = "${var.project}-rds"
  })

  lifecycle {
    #prevent_destroy = true
    ignore_changes = [
      master_user_secret_kms_key_id,
      final_snapshot_identifier
    ]
  }
}

##############################################
# CloudWatch Alarms (optional)
##############################################

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  count = length(var.alarm_actions) > 0 ? 1 : 0

  alarm_name          = "${var.project}-rds-low-storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 2000000000
  alarm_description   = "RDS free storage space below 2GB threshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.alarm_actions
  tags          = local.common_tags
}
