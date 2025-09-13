module "ControlPlane1" {


  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"
  name                   = "ControlPlane1"
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = "kube"
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    SSM_access = module.iam_policy_master.arn
    SSM_attachment = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  
  user_data = file("${path.module}/common.sh")


  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.allow_all_tcp_sg.security_group_id]
  tags = {
    Role = "SetA"
    "kubernetes.io/cluster/kubernetes" = "owned"
    "kubernetes.io/role/elb" = 1
  }
  
}

# Attach EC2 instance to Target Group
resource "aws_lb_target_group_attachment" "cp_node_attachment" {
  target_group_arn = module.loadbalancer.target_groups["tg"].arn
  target_id        = module.ControlPlane1.id
  port             = 6443
}





module "WorkerNodes" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.1"
  name                   = "WorkerNode"
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = "kube"
  # count = 3
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    SSM_access = module.iam_policy_master.arn
    SSM_attachment = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  
  # for_each = toset(["0", "1", "2"])
  # subnet_id =  element(module.vpc.private_subnets, tonumber(each.key))

  user_data = file("${path.module}/common.sh")
  subnet_id = module.vpc.private_subnets[0]

  vpc_security_group_ids = [module.allow_all_tcp_sg.security_group_id]
  tags = {
    Role = "SetC"
    "kubernetes.io/cluster/kubernetes" = "owned"
    "kubernetes.io/role/elb" = 1
  }
}

