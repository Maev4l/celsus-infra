locals {
  tags = {
    application = "celsus"
    owner       = "terraform"
    deployment  = var.environment
  }
}

