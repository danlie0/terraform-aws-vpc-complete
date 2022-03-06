
/*
resource "aws_autoscaling_group" "api-svr_asg" {
    name = "api-svr-autoscaling-group"
    desired_capacity = 2
    max_size = 4
    min_size = 2
    force_delete = true
    vpc_zone_identifier = module.dev-secure_vpc.private_subnets
    health_check_type = "EC2"
    health_check_grace_period = 300 # default is 300 seconds

    launch_template {
      id = aws_launch_template.api_svr_launch_template.id
      version = aws_launch_template.api_svr_launch_template.latest_version
    }

    #Instance refresh
    instance_refresh {
      strategy = "Rolling"
      preferences {
          instance_warmup = 300 # default behaviour is to use the auto scaling group health check grace period value
          min_healthy_percentage = 50
      }
      triggers = ["desired_capacity"] # You can add an argument from Auto Scaling Group ASG
    }

    tag {
        key                 = "Instance"
        value               = "${var.env_name}-API-SVR"
        propagate_at_launch = true
  }
}

*/