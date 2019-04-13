resource "aws_s3_bucket" "web_app" {
  bucket = "celsus.isnan.eu"
  acl    = "public-read"
  region = "${var.region}"

  policy = "${file("web-client-policy.json")}"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET"]
    max_age_seconds = "3000"
    allowed_headers = ["Authorization", "Content-Length"]
  }

  tags = "${local.tags}"
}

locals {
  s3_origin_id = "celsus-web-client"
}

resource "aws_cloudfront_distribution" "web_app_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.web_app.bucket_regional_domain_name}"
    origin_id   = "${local.s3_origin_id}"
  }

  enabled             = "true"
  is_ipv6_enabled     = "true"
  wait_for_deployment = "false"
  aliases             = ["${aws_s3_bucket.web_app.id}"]
  price_class         = "PriceClass_100"                // Only in EU and North America 

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = "true"
    target_origin_id       = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
  }

  viewer_certificate {
    acm_certificate_arn      = "${data.aws_acm_certificate.main_certificate.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  tags = "${local.tags}"
}
