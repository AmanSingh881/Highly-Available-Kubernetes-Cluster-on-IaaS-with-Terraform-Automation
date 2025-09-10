module "BastionHost" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"
  name                   = "BastionHost"
  associate_public_ip_address = true
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = "kube"
  
  # create_iam_instance_profile = true
  # iam_role_description        = "IAM role for EC2 instance"
  # iam_role_policies = {
  #   SSM_access = module.iam_policy.arn
  #   SSM_attachment = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # }


  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.allow_all_tcp_sg.security_group_id]

  tags = local.common_tags
}