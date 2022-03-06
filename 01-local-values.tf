
# locals
locals {
    owner = "terraform-ci"
    environment = var.env_name
    createdBy      = "terraform-ci"

    common_tags = {
        owners = local.owner
        environment = local.environment
    }



  asg_tags = [
    {
      key                 = "Name"
      value               = "${local.environment}-ASG-api-svr"
      propagate_at_launch = true
    }

  ]




}