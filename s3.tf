resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
}

resource "aws_s3_bucket_cors_configuration" "website_cors" {
  bucket = aws_s3_bucket.www_bucket.id
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.www_bucket.id
  index_document {
    suffix = var.index_page
  }
  error_document {
    key = var.error_page
  }
}

resource "aws_s3_bucket_acl" "website_acl" {
  bucket = aws_s3_bucket.www_bucket.id
  acl = "public-read"
}


resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.www_bucket.id
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
}
