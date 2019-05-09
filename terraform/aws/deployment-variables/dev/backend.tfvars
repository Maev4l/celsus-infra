bucket = "celsus-tf-state"

region = "eu-central-1"

key = "celsus/dev/terraform.tfstate"

encrypt = "true"

dynamodb_table = "lock-terraform-state"
