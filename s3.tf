resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
}

# For redirecting non-www to www.
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_cors_configuration" "website_cors" {
  bucket = "www.${var.bucket_name}"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = "www.${var.bucket_name}"
  index_document {
    suffix = var.index_page
  }
  error_document {
    key = var.error_page
  }
}

resource "aws_s3_bucket_website_configuration" "redirect_config" {
  bucket = var.bucket_name
  redirect_all_requests_to {
    host_name = "https://www.${var.domain_name}"
    protocol = "https"
  }
}

resource "aws_s3_bucket_acl" "website_acl" {
  bucket = "www.${var.bucket_name}"
  acl = "public-read"
}

resource "aws_s3_bucket_acl" "redirect_acl" {
  bucket = var.bucket_name
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = "www.${var.bucket_name}"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
}

resource "aws_s3_bucket_policy" "redirect_policy" {
  bucket = var.bucket_name
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
}