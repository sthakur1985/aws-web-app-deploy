#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Hello from Terraform</h1>" > /usr/share/nginx/html/index.html
