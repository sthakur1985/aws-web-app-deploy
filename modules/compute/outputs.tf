############################################
# Compute Module - Outputs
############################################

output "ec2_security_group_id" {
  description = "Security Group ID for EC2 instances (used by RDS and ALB modules)"
  value       = aws_security_group.ec2_sg.id
}

output "asg_name" {
  description = "Auto Scaling Group name for EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.name
}

output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.ec2_lt.id
}

output "launch_template_version" {
  description = "Launch template version used by ASG"
  value       = aws_launch_template.ec2_lt.latest_version
}

output "ami_id" {
  description = "AMI ID used for EC2 instances"
  value       = local.ami_id
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.ec2_asg.arn
}

output "instance_tags" {
  description = "Common tags applied to EC2 instances"
  value       = local.common_tags
}
