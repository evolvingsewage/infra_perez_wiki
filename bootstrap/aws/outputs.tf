output "state_bucket_name" {
  description = "Use as the `bucket` value in aws/jenkins's backend config."
  value       = aws_s3_bucket.tfstate.id
}

output "state_bucket_arn" {
  value = aws_s3_bucket.tfstate.arn
}

output "state_bucket_region" {
  value = var.aws_region
}
