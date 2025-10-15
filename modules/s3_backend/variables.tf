variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
