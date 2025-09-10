module "loadbalancer" {

    # Ensure delay happens before execution
  depends_on = [
    time_sleep.wait_2_minutes
  ]
  source  = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name_prefix = "kubem-"
  load_balancer_type               = "network"
  vpc_id                           = module.vpc.vpc_id
  dns_record_client_routing_policy = "availability_zone_affinity"
  security_groups = [module.allow_all_tcp_sg.security_group_id]

  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  # Listener
  listeners = {
    ex-listener = {
      port     = 6443
      protocol = "TCP"

      forward = {
        target_group_key = "tg"
      }
    }
  }
  


  # Target Groups
  target_groups = {
    tg = {
      create_attachment    = false
      name_prefix          = "tg-"
      protocol             = "TCP"
      port                 = 6443
      target_type          = "instance"
      deregistration_delay = 10

      # Health check for TCP target group (no path, just port check)
      health_check = {
        protocol            = "TCP"
        enabled             = true
        interval            = 10
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    }
  
  }# End Target Group-1: mytg1
  
  tags = local.common_tags
}

# output "load_balancer_dns" {
#   description = "The DNS name of the load balancer"
#   value       = module.loadbalancer.this_lb_dns_name
# }

# Store the NLB DNS name in SSM Parameter Store
resource "aws_ssm_parameter" "nlb_dns" {
  name  = "/myapp/nlb_dns"
  type  = "String"
  value = module.loadbalancer.dns_name
  tags = local.common_tags
}


