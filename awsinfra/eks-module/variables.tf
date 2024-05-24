terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "aws_mfa"
}
variable "eks_name" {
  type    = string
  default = "js-test-eks"
}
variable "eks_version" {
  type    = number
  default = 1.29
}
variable "vpc_cni_role_name" {
  type    = string
  default = "vpc-cni-js-test-role"
}