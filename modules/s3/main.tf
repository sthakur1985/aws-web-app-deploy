############################################
# S3 Module - Static Content Hosting
############################################

resource "aws_s3_bucket" "static_content" {
  bucket = "${var.project_name}-${var.env}-static-content"

  tags = {
    Name        = "${var.project_name}-${var.env}-static-content"
    Environment = var.env
    Project     = var.project_name
    Owner       = var.costcenter
  }
}

resource "aws_s3_bucket_public_access_block" "static_content" {
  bucket = aws_s3_bucket.static_content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "static_content" {
  bucket = aws_s3_bucket.static_content.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_content" {
  bucket = aws_s3_bucket.static_content.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "static_content" {
  name                              = "${var.project_name}-${var.env}-oac"
  description                       = "OAC for ${var.project_name} static content"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

