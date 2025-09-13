module "allow_all_tcp_sg" {

  depends_on = [module.vpc]
  source     = "terraform-aws-modules/security-group/aws"
  version    = "5.3.0"

  name        = "allow-all-tcp-sg"
  description = "Security Group that allows all TCP traffic on all ports"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow all TCP traffic from anywhere"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # Allow all outbound traffic
  egress_rules = ["all-all"]

  tags = local.common_tags
}
