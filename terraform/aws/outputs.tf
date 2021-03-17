output "mainVPC" {
  value = aws_vpc.main_vpc.id
}

output "mainVPCSubnet1" {
  value = aws_subnet.main_vpc_subnet_1.id
}

output "mainVPCSubnet2" {
  value = aws_subnet.main_vpc_subnet_2.id
}

output "mainVPCSubnet3" {
  value = aws_subnet.main_vpc_subnet_3.id
}

output "region" {
  value = var.region
}

output "availabilityZones" {
  value = data.aws_availability_zones.available.*.names
}

output "mainVPCDefaultSecurityGroup" {
  value = aws_vpc.main_vpc.default_security_group_id
}

output "coreStorageSecurityGroup" {
  value = aws_security_group.core_storage_security_group.id
}

output "certificate" {
  value = data.aws_acm_certificate.main_certificate.arn
}

output "coreStorageHostname" {
  value = aws_db_instance.core_storage.address
}

output "lambdaExecutionRoleArn" {
  value = data.aws_iam_role.lambda_vpc_execution_role.arn
}

output "hostedZone" {
  value = data.aws_route53_zone.primary.zone_id
}

output "userPoolArn" {
  value = aws_cognito_user_pool.user_pool.arn
}

output "userPoolId" {
  value = aws_cognito_user_pool.user_pool.id
}

output "userPoolClient" {
  value = aws_cognito_user_pool_client.client.id
}

output "userIdentityPool" {
  value = aws_cognito_identity_pool.identity_pool.id
}

output "environment" {
  value = var.environment
}

output "coreQueueArn" {
  value = aws_sqs_queue.core_queue.arn
}

output "coreQueueUrl" {
  value = aws_sqs_queue.core_queue.id
}

output "contactsQueueArn" {
  value = aws_sqs_queue.contacts_queue.arn
}

output "contactsQueueUrl" {
  value = aws_sqs_queue.contacts_queue.id
}

output "lendingsQueueArn" {
  value = aws_sqs_queue.lendings_queue.arn
}

output "lendingsQueueUrl" {
  value = aws_sqs_queue.lendings_queue.id
}

output "webClientStaticHost" {
  value = aws_s3_bucket.web_app.bucket_regional_domain_name
}

output "webClientDistribution" {
  value = aws_cloudfront_distribution.web_app_distribution.id
}


