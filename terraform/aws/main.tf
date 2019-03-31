terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.main_vpc_cidr_block}"
  enable_dns_hostnames = true

  tags = "${local.tags}"
}

resource "aws_subnet" "main_vpc_subnet_1" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  cidr_block        = "${cidrsubnet(var.main_vpc_cidr_block,8,1)}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = "${local.tags}"
}

resource "aws_internet_gateway" "main_vpc_internet_gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = "${local.tags}"
}
