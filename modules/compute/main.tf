# Security group for EC2 allowing traffic from ALB
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-${var.env}-ec2-sg"
  vpc_id      = var.vpc_id
  description = "Allow inbound from ALB and outbound to anywhere"


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ALB will target via SG but for simplicity we allow 80 from anywhere; lock down by using ALB SG in production
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Environment = var.env
    Project     = var.project
    Owner       = var.costcenter
    managedby   = "terraform"
  }
}











data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "ec2_lt" {
  name_prefix   = "${var.costcenter}-${var.env}-lt"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  user_data = filebase64(var.user_data_path)

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.costcenter}-${var.env}-ec2"
      Environment = var.env
      Project     = var.costcenter
      Owner       = var.owner
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ec2_asg" {
  name                      = "${var.costcenter}-${var.env}-asg"
  desired_capacity          = var.asg_desired_capacity
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }

  target_group_arns = var.alb_target_group_arn != null ? [var.alb_target_group_arn] : []

  tag {
    key                 = "Name"
    value               = "${var.costcenter}-${var.env}-ec2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  }
}