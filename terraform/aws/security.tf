// Allows Lambda functions to call AWS services on your behalf
data "aws_iam_role" "lambda_vpc_execution_role" {
  name = "lambda-vpc-execution-role"
}


// Policy for devs (so update of the S3 bucket containing the frontend assets is possible)
data "aws_iam_policy_document" "webapp_s3_policy_dev" {
  statement {
    actions   = ["s3:*"]
    resources = ["${aws_s3_bucket.web_app.arn}"]
  }
}

// Policy for devs (so update of the S3 bucket containing the frontend assets is possible)
resource "aws_iam_policy" "web_app_dev_policy" {
  name   = "WriteWebAppS3Bucket"
  policy = "${data.aws_iam_policy_document.webapp_s3_policy_dev.json}"
}
