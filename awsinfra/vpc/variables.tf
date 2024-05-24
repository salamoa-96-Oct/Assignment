terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "aws_mfa"
}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "region_az_a" {
  type    = string
  default = "ap-northeast-2a"
}
variable "region_az_c" {
  type    = string
  default = "ap-northeast-2c"
}
variable "js_cluster_name" {
  type    = string
  default = "js-test-eks"
}