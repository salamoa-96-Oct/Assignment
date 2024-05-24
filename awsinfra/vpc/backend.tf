terraform {
  backend "s3" {
    bucket         = "terraform-state-js-test"
    key            = "test/infra/vpc/terraform.state"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "aws_mfa"
  }
}
