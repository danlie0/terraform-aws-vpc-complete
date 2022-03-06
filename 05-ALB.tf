
# Application Load Balancer to reside in Secure VPC (ALB)
module "alb" {
  depends_on = [module.ec2_instance_api-svr] 
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "${var.env_name}-api-svr-alb"

  load_balancer_type = "application"

  vpc_id             = module.dev-secure_vpc.vpc_id
  subnets            = module.dev-secure_vpc.public_subnets
  security_groups    = [aws_security_group.TEST-ELB-Web-Secure.id]


# Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
# Target Groups
 target_groups = [
    # API-SVR Target Group - Target Group Index = 0
    {
      name_prefix          = "tg-api"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      targets = {
        ec2_api_server = { 
          target_id = module.ec2_instance_api-svr.id  # TO DO: CHANGE TO API SERVER
          port      = 80
        }
      }
      
    }  
  ]
  #tags = local.common_tags # ALB Tags
}