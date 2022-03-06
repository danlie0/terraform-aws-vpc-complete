/*

data "template_file" "user_data" {
  template = file("userdata.tpl")
}

# Create launch template for EC2 auto-scaling group
resource "aws_launch_template" "api_svr_launch_template" {
  name = "my-launchtemplate-api-svr"
  description = "my launch template description"
  image_id = data.aws_ami.amz_linux2.id
  instance_type = "t2.micro"
  ebs_optimized = true

 credit_specification {
    cpu_credits = "standard" # Check with oz if this should be changed to unlimited
  } 

#security group to add to 
vpc_security_group_ids = [aws_security_group.TEST-secure-api-svr-sg.id, aws_security_group.TEST-Management.id]  #TO DO change this depending on the ec2 instance in the secure vpc you are creating. atm it is pointint to the public vpc sg as a test
key_name = var.instance_keypair # Change this variable in terraform.tfvars to tipton_staging_key"
user_data = filebase64("${path.module}/app1-install.sh")

update_default_version = true # when ever launch template is deployed with changed, ensure version is updated


block_device_mappings {
  device_name = "/dev/sda1"
  ebs {
    volume_size = 10 #10GB is fine for most servers but the SVR-AGT needs 80gb in its template
    delete_on_termination = true
    #volume_type = "gb2" # default is gp2
  }
}
monitoring {
  enabled = false
}
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "myasg"
      Source = "Autoscaling"
    }
  }  
}

*/