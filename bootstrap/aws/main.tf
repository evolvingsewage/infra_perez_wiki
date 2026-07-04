data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.bucket_name_prefix}-${data.aws_caller_identity.current.account_id}"
}

variable "bucket_already_exists" {
  description = "Set true by the calling workflow after a create attempt fails with BucketAlreadyOwnedByYou, to import the existing bucket instead of trying to recreate it."
  type        = bool
  default     = false
}

import {
  for_each = var.bucket_already_exists ? toset(["this"]) : toset([])
  to       = aws_s3_bucket.tfstate
  id       = local.bucket_name
}

resource "aws_s3_bucket" "tfstate" {
  bucket = local.bucket_name

  # Guards against `terraform destroy` silently deleting years of state
  # history. This config runs on every deploy
  lifecycle {
    prevent_destroy = true
  }
}

# Recovery point, just in case...
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# SSE-S3 rather than a customer-managed KMS key for cost saving
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Terraform state can contain secrets, keep it out of public
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# block insecure connections
resource "aws_s3_bucket_policy" "tfstate_tls_only" {
  bucket = aws_s3_bucket.tfstate.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.tfstate.arn,
          "${aws_s3_bucket.tfstate.arn}/*",
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
