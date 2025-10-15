resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  tags = merge(
    var.common_tags,
    { Name = "${var.bucket_name}" }
  )
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Optional lifecycle rule to retain older states for 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "retain-old-versions"
    status = "Enabled"

    filter {
      prefix = ""  
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
