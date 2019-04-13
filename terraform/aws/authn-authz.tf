resource "aws_cognito_user_pool" "user_pool" {
  name = "celsus_user_pool"

  password_policy = {
    minimum_length    = "8"
    require_lowercase = "true"
    require_numbers   = "true"
    require_symbols   = "true"
    require_uppercase = "true"
  }

  admin_create_user_config = {
    allow_admin_create_user_only = "false"
    unused_account_validity_days = "7"
  }

  user_pool_add_ons = {
    advanced_security_mode = "OFF"
  }

  tags = "${local.tags}"
}

resource "aws_cognito_user_pool_client" "client" {
  name                = "celsus_client"
  user_pool_id        = "${aws_cognito_user_pool.user_pool.id}"
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "celsus_identity_pool"
  allow_unauthenticated_identities = "false"

  cognito_identity_providers {
    provider_name           = "${aws_cognito_user_pool.user_pool.endpoint}"
    client_id               = "${aws_cognito_user_pool_client.client.id}"
    server_side_token_check = "true"
  }
}
