terraform {
    backend "s3" {}
}

provider "aws" {
    region = "${var.region}"
}

locals {
    vpc_id = "vpc-8c20e6e4" // default VPC (automatically created by AWS)
}
data "aws_vpc" "main_vpc" {
    id = "${local.vpc_id}"
}

resource "aws_sns_topic" "books_updates" {
  name ="books-updates-topic"
}

