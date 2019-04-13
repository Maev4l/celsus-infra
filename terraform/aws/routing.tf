provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_acm_certificate" "main_certificate" {
  provider = "aws.us-east-1"
  domain   = "*.isnan.eu"
}

data "aws_route53_zone" "hosted_zone" {
  name = "isnan.eu."
}
