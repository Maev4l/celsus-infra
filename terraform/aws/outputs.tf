output "mainVPC" {
  value = "${aws_vpc.main_vpc.id}"
}

output "mainVPCSubnet1" {
  value = "${aws_subnet.main_vpc_subnet_1.id}"
}

output "mainVPCSubnet2" {
  value = "${aws_subnet.main_vpc_subnet_2.id}"
}

output "mainVPCSubnet3" {
  value = "${aws_subnet.main_vpc_subnet_3.id}"
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

output "hostedZone" {
  value = "${data.aws_route53_zone.hosted_zone.zone_id}"
}

output "userPoolArn" {
  value = "${aws_cognito_user_pool.user_pool.arn}"
}

output "userPoolId" {
  value = "${aws_cognito_user_pool.user_pool.id}"
}

output "userPoolClient" {
  value = "${aws_cognito_user_pool_client.client.id}"
}

output "messagingBooksTopic" {
  value = "${aws_sns_topic.books_updates.id}"
}
