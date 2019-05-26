variable "region" {
  type        = string
  description = "Deployment region"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (eg. dev, test,prod, etc ..)"
}

variable "main_vpc_cidr_block_prefix" {
  type        = string
  description = "Main VPC CIDR block prefix"
}

variable "core_storage_username" {
  type        = string
  description = "Username for core storage"
}

variable "core_storage_password" {
  type        = string
  description = "Password for core storage"
}

variable "core_storage_port" {
  type        = string
  description = "Port number for core storage"
}

variable "local_ips" {
  type        = list(string)
  description = "Local machine IP address"
}

