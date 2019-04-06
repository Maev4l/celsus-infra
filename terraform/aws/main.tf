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
  vpc_id = "${aws_vpc.main_vpc.id}"
  count  = "${local.subnet_count}"

  cidr_block        = "${var.main_vpc_cidr_block_prefix}.${count.index * 16}.0/20"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${local.tags}"
}

resource "aws_internet_gateway" "main_vpc_internet_gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags = "${local.tags}"
}

resource "aws_route_table" "main_vpc_route_table" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_vpc_internet_gateway.id}"
  }

  tags = "${local.tags}"
}

resource "aws_route_table_association" "main_vpc_route_table_association_1" {
  subnet_id      = "${aws_subnet.main_vpc_subnets.0.id}"
  route_table_id = "${aws_route_table.main_vpc_route_table.id}"
}

/*
resource "aws_default_route_table" "main_vpc_internet_gateway" {
  default_route_table_id = "${aws_vpc.main_vpc.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_vpc_internet_gateway.id}"
  }

  tags = "${local.tags}"
}
*/

