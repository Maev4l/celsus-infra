output "main-vp" {
  value = "${aws_vpc.main_vpc.id}"
}

output "main-vpc-subnet-1" {
  value = "${aws_vpc.main_vpc.id}"
}

output "main-vpc-default-security-group" {
  value = "${aws_vpc.main_vpc.default_security_group_id}"
}

output "sns-books-topic" {
  value = "${aws_sns_topic.books_updates.id}"
}
