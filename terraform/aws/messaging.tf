resource "aws_sqs_queue" "dead_letter_queue" {
  name                       = "celsus_dead_letter_queue"
  visibility_timeout_seconds = "360"

  tags = local.tags
}

resource "aws_sqs_queue" "core_queue" {
  name = "celsus_core_queue"

  visibility_timeout_seconds = "180"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":5}"
  tags                       = local.tags
}

resource "aws_sqs_queue" "contacts_queue" {
  name = "celsus_contacts_queue"

  visibility_timeout_seconds = "180"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":5}"
  tags                       = local.tags
}

resource "aws_sqs_queue" "lendings_queue" {
  name = "celsus_lendings_queue"

  visibility_timeout_seconds = "180"
  redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":5}"
  tags                       = local.tags
}