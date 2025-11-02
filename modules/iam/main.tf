############################################
# IAM Module - Centralized IAM Resources
############################################

# EC2 assume role policy document
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# EC2 IAM role
resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-${var.env}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "${var.project_name}-${var.env}-ec2-role"
    Environment = var.env
    Project     = var.project_name
    Owner       = var.costcenter
  }
}

# EC2 instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.project_name}-${var.env}-ec2-profile"
    Environment = var.env
    Project     = var.project_name
    Owner       = var.costcenter
  }
}

# Attach SSM managed policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# RDS monitoring role (if enhanced monitoring is enabled)
resource "aws_iam_role" "rds_monitoring" {
  count = var.enable_rds_monitoring ? 1 : 0
  name  = "${var.project_name}-${var.env}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.env}-rds-monitoring-role"
    Environment = var.env
    Project     = var.project_name
    Owner       = var.costcenter
  }
}

# Attach RDS enhanced monitoring policy
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count      = var.enable_rds_monitoring ? 1 : 0
  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}