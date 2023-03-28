data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
data "aws_region" "current" {}


output "region" {
  value = data.aws_region.current.name
}
//參考 https://stackoverflow.com/questions/68397972/how-to-use-aws-account-id-variable-in-terraform