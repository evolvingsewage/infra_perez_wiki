variable "aws_region" {
  description = "Region for the state bucket. Keep this the same to avoid cross-region data transfer."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the state bucket"
  type        = string
  default     = "infra-perez-wiki-tfstate"
}
