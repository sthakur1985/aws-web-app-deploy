variable "aws_region" { 
    description = "aws region to deploy" 
    type = string
}
variable "instance_type" {
    description = "instance type to deploy"
    type = string
    default = "t3.micro"
} 
variable "env" {
    description = "environment name to deploy"
    type = string
    default = "dev"
}  
variable "project" {
    description = "project name to deploy"
    type = string
    default = "aws-web-app"
} 
variable "costcenter" { 
    description = "costcenter to deploy"
    type = string
    default = "aws-web-app"
}
 
variable "azs" {
type = list(string)
default = []
}


variable "vpc_id" {
  description = "ID of the VPC where EC2 instances will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group to register instances"
  type        = string
  default     = null
}



variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
  default     = ""
}

variable "asg_min_size" {
  description = "Minimum number of instances in Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in Auto Scaling Group"
  type        = number
  default     = 1
}




variable "owner" {
  description = "Owner or team responsible for this deployment"
  type        = string
}

variable "user_data_path" {
  description = "Path to user data script file"
  type        = string
  default     = "userdata.sh.tpl"
}

variable "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile from IAM module"
  type        = string
}