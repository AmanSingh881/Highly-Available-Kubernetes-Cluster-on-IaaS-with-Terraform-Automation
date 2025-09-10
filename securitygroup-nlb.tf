# # Security Group for Public Load Balancer
# module "loadbalancerSG" {

#   depends_on = [ module.vpc ]
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.3.0"  

#   name = "loadbalancerSG"
#   description = "Security Group with HTTP open for Load Balancer (IPv4 CIDR)"
#   vpc_id = module.vpc.vpc_id

#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 6443
#       to_port     = 6443
#       protocol    = "tcp"
#       description = "kube api-server"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       from_port   = 0
#       to_port     = 65535
#       protocol    = "tcp"
#       description = "internal"
#       cidr_blocks = "10.0.0.0/16"
#     },

#   ]

#   egress_rules = ["all-all"]
#   tags = local.common_tags
# }

