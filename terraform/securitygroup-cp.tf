# module "securityGroupCP" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.3.0"     
  
#   name = "MasterSG"
#   description = "Allow HTTP from ALB SG and SSH from Bastion SG"
#   vpc_id      = module.vpc.vpc_id


#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 6443
#       to_port     = 6443
#       protocol    = "tcp"
#       description = "kube api-server"
#       cidr_blocks = "10.0.0.0/16"
#     },
#     {
#       from_port   = 10259
#       to_port     = 10259
#       protocol    = "tcp"
#       description = "kube scheduler"
#       cidr_blocks = "10.0.0.0/16"
#     },
#     {
#       from_port   = 10250
#       to_port     = 10250
#       protocol    = "tcp"
#       description = "kubelet api"
#       cidr_blocks = "10.0.0.0/16"
#     },
#     {
#       from_port   = 10257
#       to_port     = 10257
#       protocol    = "tcp"
#       description = "kube-controller manager"
#       cidr_blocks = "10.0.0.0/16"
#     },
#     {
#       from_port   = 2379
#       to_port     = 2380
#       protocol    = "tcp"
#       description = "kube apiserver, etcd"
#       cidr_blocks = "10.0.0.0/16"
#     },
#   ]

#   ingress_rules = ["ssh-tcp"]
#   ingress_cidr_blocks = ["0.0.0.0/0"]

#   egress_rules = ["all-all"] 
#   tags         = local.common_tags

# }

