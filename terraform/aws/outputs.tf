output "mainVPC" {
  value = "${aws_vpc.main_vpc.id}"
}

output "mainVPCSubnet1" {
  value = "${aws_subnet.main_vpc_subnets.0.id}"
}

output "mainVPCSubnet2" {
  value = "${aws_subnet.main_vpc_subnets.1.id}"
}

output "mainVPCSubnet3" {
  value = "${aws_subnet.main_vpc_subnets.2.id}"
}

output "region" {
  value = "${var.region}"
}

output "availabilityZones" {
  value = "${data.aws_availability_zones.available.*.names}"
}

output "mainVPCDefaultSecurityGroup" {
  value = "${aws_vpc.main_vpc.default_security_group_id}"
}

output "coreStorageSecurityGroup" {
  value = "${aws_security_group.core_storage_security_group.id}"
}

output "coreStorageHostname" {
  value = "${aws_db_instance.core_storage.address}"
}

output "lambdaExecutionRoleArn" {
  value = "${data.aws_iam_role.lambda_vpc_execution_role.arn}"
}

output "messagingBooksTopic" {
  value = "${aws_sns_topic.books_updates.id}"
}
