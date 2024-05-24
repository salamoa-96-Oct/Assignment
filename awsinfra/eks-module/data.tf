data "terraform_remote_state" "js_vpc" {
  backend = "s3"
  config = {
    bucket         = "terraform-state-js-test"
    key            = "test/infra/vpc/terraform.state"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "aws_mfa"
  }
}