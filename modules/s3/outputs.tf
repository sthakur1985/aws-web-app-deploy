############################################
# S3 Module - Outputs
############################################

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.static_content.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.static_content.arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.static_content.bucket_domain_name
}

output "origin_access_control_id" {
  description = "CloudFront Origin Access Control ID"
  value       = aws_cloudfront_origin_access_control.static_content.id
}