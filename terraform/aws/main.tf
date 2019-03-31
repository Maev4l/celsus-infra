terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.main_vpc_cidr_block_prefix}.0.0/16"
  enable_dns_hostnames = true

  tags = "${local.tags}"
}
locals {
  subnet_count = 3
}
resource "aws_subnet" "main_vpc_subnets" {
  vpc_id            = "${aws_vpc.main_vpc.id}"
  count             = "3"
  // cidr_block              = "10.0.${local.subnet_count * (var.infrastructure_version - 1) + count.index + 1}.0/24"
  cidr_block        = "${var.main_vpc_cidr_block_prefix}.${count.index * 16}.0/20"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${local.tags}"
}

resource "aws_internet_gateway" "main_vpc_internet_gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = "${local.tags}"
}
