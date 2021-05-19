terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = "${var.main_vpc_cidr_block_prefix}.0.0/16"
  enable_dns_hostnames = "true"

  tags = local.tags
}

locals {
  subnet_count = length(data.aws_availability_zones.available.names)
}

resource "aws_subnet" "main_vpc_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id

  cidr_block        = "${var.main_vpc_cidr_block_prefix}.${0 * 16}.0/20"
  availability_zone = element(data.aws_availability_zones.available.names, 0)

  tags = local.tags
}

resource "aws_subnet" "main_vpc_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id

  cidr_block        = "${var.main_vpc_cidr_block_prefix}.${1 * 16}.0/20"
  availability_zone = element(data.aws_availability_zones.available.names, 1)

  tags = local.tags
}

resource "aws_subnet" "main_vpc_subnet_3" {
  vpc_id = aws_vpc.main_vpc.id

  cidr_block        = "${var.main_vpc_cidr_block_prefix}.${2 * 16}.0/20"
  availability_zone = element(data.aws_availability_zones.available.names, 2)

  tags = local.tags
}

// Need this IGW, so the RDS instance is accessible from the internet via dns name
resource "aws_internet_gateway" "main_vpc_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = local.tags
}

resource "aws_route_table" "vpc_primary_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  // Need this IGW, so the RDS instance is accessible from the internet via dns name
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_internet_gateway.id
  }

  tags = local.tags
}

resource "aws_route_table" "vpc_secondary_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = local.tags
}

resource "aws_route_table_association" "vpc_primary_route_table_association_1" {
  subnet_id      = aws_subnet.main_vpc_subnet_1.id
  route_table_id = aws_route_table.vpc_primary_route_table.id
}

resource "aws_route_table_association" "vpc_secondary_route_table_association_2" {
  subnet_id      = aws_subnet.main_vpc_subnet_2.id
  route_table_id = aws_route_table.vpc_secondary_route_table.id
}

resource "aws_route_table_association" "vpc_secondary_route_table_association_3" {
  subnet_id      = aws_subnet.main_vpc_subnet_3.id
  route_table_id = aws_route_table.vpc_secondary_route_table.id
}


data "template_file" "main_vpc_endpoint_message_queues_policy" {
  template = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [{
      "Action": ["sqs:SendMessage"],
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
   }]
}
EOF

}

resource "aws_vpc_endpoint" "main_vpc_endpoint_message_queues" {
  vpc_id              = aws_vpc.main_vpc.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.sqs"
  subnet_ids          = [aws_subnet.main_vpc_subnet_2.id]
  security_group_ids  = [aws_vpc.main_vpc.default_security_group_id]
  private_dns_enabled = true

  policy = data.template_file.main_vpc_endpoint_message_queues_policy.rendered

  tags = local.tags
}


data "template_file" "main_vpc_endpoint_s3_policy" {
  template = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": [{
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
   }]
}
EOF

}

resource "aws_vpc_endpoint" "main_vpc_endpoint_s3" {
  vpc_id            = aws_vpc.main_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"

  policy = data.template_file.main_vpc_endpoint_s3_policy.rendered

  tags = local.tags
}


resource "aws_vpc_endpoint_route_table_association" "subnet2_endpoint_s3" {
  route_table_id  = aws_route_table.vpc_secondary_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.main_vpc_endpoint_s3.id
}

