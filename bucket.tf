# resource "aws_s3_bucket" "bucket-backend" {
#   bucket = var.bucket_name
#   tags   = var.tags
# }

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = var.bucket_name

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = var.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
