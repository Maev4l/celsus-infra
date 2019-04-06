// Allows Lambda functions to call AWS services on your behalf
data "aws_iam_role" "lambda_vpc_execution_role" {
  name = "lambda-vpc-execution-role"
}
