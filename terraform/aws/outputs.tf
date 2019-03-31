output "main-vp" {
  value = "${aws_vpc.main_vpc.id}"
}

output "main-vpc-subnets" {
  value = "${aws_subnet.main_vpc_subnets.*.id}"
}

output "availability-zone-1" {
  value = "${data.aws_availability_zones.available.names[0]}"
}

output "main-vpc-default-security-group" {
  value = "${aws_vpc.main_vpc.default_security_group_id}"
}

output "sns-books-topic" {
  value = "${aws_sns_topic.books_updates.id}"
}
