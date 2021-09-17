
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "3.7.0"
  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.vpc_availability_zones
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  create_igw      = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway # all private subnets only connected to one nat

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    Type = "public-subnets"
  }

  private_subnet_tags = {
    Type = "private-subnets"
  }


  tags = local.common_tags

  vpc_tags = {
    Name = var.vpc_name
  }

}
