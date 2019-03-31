// Storage for core services
resource "aws_db_subnet_group" "core_storage_subnet_group" {
  name       = "core_storage_subnet_group"
  subnet_ids = ["${aws_subnet.main_vpc_subnets.*.id}"]

  tags = "${local.tags}"
}

resource "aws_db_instance" "core_storage" {
  identifier                 = "celsus-core-storage"
  skip_final_snapshot        = "true"
  allocated_storage          = 20
  auto_minor_version_upgrade = "true"
  storage_type               = "gp2"
  engine                     = "postgres"
  instance_class             = "db.t2.micro"
  name                       = "celsuscorestorage"
  db_subnet_group_name       = "${aws_db_subnet_group.core_storage_subnet_group.name}"
  apply_immediately          = "true"
  availability_zone          = "${data.aws_availability_zones.available.names[0]}"
  multi_az                   = "false"
  username                   = "${var.core_storage_username}"
  password                   = "${var.core_storage_password}"
  port                       = "${var.core_storage_port}"
  
  tags = "${local.tags}"
}