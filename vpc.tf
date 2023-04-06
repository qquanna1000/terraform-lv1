/*
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-eest-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24","10.0.4.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = merge(var.tags,{Name = "${var.prefix}vpc"})
}
*/