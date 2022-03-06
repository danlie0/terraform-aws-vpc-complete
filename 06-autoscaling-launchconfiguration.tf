# Autoscaling with Launch Configuration - Both created at a time
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.1.0"

  # Autoscaling group
  name            = "${local.environment}-myasg"
  use_name_prefix = false

  min_size                  = 3
  max_size                  = 5
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.dev-secure_vpc.private_subnets
  #service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn


  # Associate ALB with ASG
  target_group_arns         = module.alb.target_group_arns

  # ASG Lifecycle Hooks
  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    }
  ]

  # ASG Instance Referesh
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag", "desired_capacity"] # Desired Capacity here added for instance refresh
  }

  # ASG Launch configuration
  lc_name   = "${local.environment}-mylc1"
  use_lc    = true
  create_lc = true

  image_id          = data.aws_ami.amz_linux2.id
  instance_type     = var.instance_type_api_svr
  key_name          = var.instance_keypair
  user_data         = file("${path.module}/app1-install.sh")
  ebs_optimized     = false
  enable_monitoring = false

  security_groups             = [aws_security_group.TEST-secure-api-svr-sg.id, aws_security_group.TEST-Management.id] 
  associate_public_ip_address = false


  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = false
      volume_size           = "8"
      volume_type           = "gp2"
    },
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" # At production grade you can change to "required"?
    http_put_response_hop_limit = 32
  }

  tags  = local.asg_tags 
}