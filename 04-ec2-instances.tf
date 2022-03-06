

# Create Windows Linux host which be on a public subnet in public vpc
module "ec2_instance_linux_bastion" {
  depends_on = [module.dev-general-vpc]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.env_name}-Linux-BastionHost"

  ami                    = data.aws_ami.ubuntu.id # 
  instance_type          = var.instance_type_linux_bastion
  key_name               = var.instance_keypair
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.TEST-General-sg.id]
  subnet_id              = element(module.dev-general-vpc.public_subnets, 0)
  associate_public_ip_address = true 
  source_dest_check           = true

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2" # TO do check if we should use gp2
      volume_size = 50
      delete_on_termination = false
    }
  ]
 tags = {
    "host"        = "${var.env_name}_bastion_host"
    "Name"        = "${var.env_name}_bastion_host"
    "Patch Group" = "Ubuntu_Servers"
  }

  
}



# Create Windows Bastion host which will be on public subnet in public vpc
module "ec2_instance_windows_bastion" {
  depends_on = [module.dev-general-vpc]
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.env_name}-Windows-BastionHost"

  ami                    = data.aws_ami.windows.id
  instance_type          = var.instance_type_windows_bastion
  key_name               = var.instance_keypair
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.TEST-General-sg.id]
  subnet_id              = element(module.dev-general-vpc.public_subnets, 0)
  associate_public_ip_address = true
  source_dest_check           = true

    root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2" # TO do check if we should use gp2
      volume_size = 50
      delete_on_termination = false
    }
  ]

    tags = {
    "Patch Group" = "Windows_Servers"
    "Name"        = "${var.env_name}_Bastion_Windows"
    "Host"        = "${var.env_name}_Bastion_Windows"
  }
}




# Create API-SVR in secure VPC
module "ec2_instance_api-svr" {
  depends_on = [module.dev-secure_vpc] 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.env_name}-API-svr"

  ami                    = data.aws_ami.amz_linux2.id
  instance_type          = var.instance_type_api_svr
  key_name               = var.instance_keypair
  #iam_instance_profile   = "EC2SSM" # TO DO: Unable to create this due to permissions
  associate_public_ip_address = false
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.TEST-secure-api-svr-sg.id, aws_security_group.TEST-Management.id] 
  subnet_id              = module.dev-secure_vpc.private_subnets[0]
  source_dest_check           = true
  user_data = file("${path.module}/app1-install.sh")

    root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2" # TO do check if we should use gp3
      volume_size = 50
      delete_on_termination = false
    }
  ]

  tags = local.common_tags
}



# Create RPA-AGT Server in secure VPC
module "ec2_instance_rpa-agt-svr" {
  depends_on = [module.dev-secure_vpc] 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.env_name}-RPA-AGT-svr"

  ami                    = data.aws_ami.amz_windows.id
  instance_type          = var.instance_type_api_svr
  key_name               = var.instance_keypair
  #iam_instance_profile   = aws_iam_instance_profile.EC2SSM_profile.name
  associate_public_ip_address = false
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.TEST-rpaagt1-sg.id]
  subnet_id              = module.dev-secure_vpc.private_subnets[2]
  source_dest_check           = true
   user_data = file("${path.module}/app1-install.sh")
# have not added private IP's

    root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2" # TO do check if we should use gp2
      volume_size = 100
      delete_on_termination = false
    }
  ]

  tags = {
    "Patch Group" = "Windows_Servers"
    "Name"        = "${var.env_name}_RPAAGT"
    "UpdateGroup" = "CriticalPatches"
    "Host"        = "${var.env_name}_RPAAGT"
  }
}


# Create RPA-SVR Server in secure VPC
module "ec2_instance_rpa-svr-svr" {
  depends_on = [module.dev-secure_vpc] 
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${var.env_name}-RPA-svr"

  ami                    = data.aws_ami.amz_linux2.id
  instance_type          = var.instance_type_api_svr
  key_name               = var.instance_keypair
  #iam_instance_profile   = aws_iam_instance_profile.EC2SSM_profile.name
  associate_public_ip_address = false
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.TEST-rpasvr-sg.id]
  subnet_id              = module.dev-secure_vpc.private_subnets[2]
  source_dest_check           = true
   user_data = file("${path.module}/app1-install.sh")
# have not added private IP's

    root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2" # TO do check if we should use gp2
      volume_size = 100
      delete_on_termination = false
    }
  ]

  tags = {
    "Patch Group" = "Ubuntu_Servers"
    "host"        = "${var.env_name}_RPASVR"
    "Name"        = "${var.env_name}_RPASVR"
  }
}