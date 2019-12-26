locals {
  bucket_name = "celsus.isnan.eu"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "CloudFront identity to access celsus frontend assets bucket"
}


resource "aws_s3_bucket" "web_app" {
  bucket = local.bucket_name
  region = var.region

  tags = local.tags
}

data "aws_iam_policy_document" "webapp_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_app.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.web_app.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web_app_bucket_policy" {
  bucket = aws_s3_bucket.web_app.id
  policy = data.aws_iam_policy_document.webapp_s3_policy.json
}

locals {
  s3_origin_id = "celsus-web-client"
}

resource "aws_cloudfront_distribution" "web_app_distribution" {
  origin {
    domain_name = aws_s3_bucket.web_app.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  default_root_object = "index.html"
  enabled             = "true"
  is_ipv6_enabled     = "true"
  wait_for_deployment = "false"
  aliases             = [local.bucket_name]
  price_class         = "PriceClass_100" // Only in EU and North America 

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = "true"
    target_origin_id       = local.s3_origin_id

    forwarded_values {
      query_string = "false"

      cookies {
        forward = "none"
      }
    }

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.main_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  tags = local.tags
}

