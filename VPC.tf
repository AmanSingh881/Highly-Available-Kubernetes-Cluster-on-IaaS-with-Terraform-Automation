# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  # VPC Basic Details
  name = "k8s VPC"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1c"]
  public_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  
  enable_dns_hostnames = true
  enable_dns_support   = true 
  # NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true



  tags = local.common_tags
  vpc_tags = local.common_tags

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  nat_gateway_tags = local.common_tags

}