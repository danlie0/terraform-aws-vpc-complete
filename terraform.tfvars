# Secure VPC Variables
vpc_secure_name            = "dev-secure-vpc"
vpc_secure_cidr_block      = "192.168.0.0/21"
vpc_secure_private_subnet  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"] 
vpc_secure_public_subnet   = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
availability_zones         = ["us-west-2a", "us-west-2b", "us-west-2c"]#UPDATE TO EU



# Public VPC Variables
vpc_general_name            = "dev-general-vpc"
vpc_general_cidr_block      = "192.168.8.0/21"
availability_zones_general  = ["us-west-2a", "us-west-2b"] #UPDATE TO EU
vpc_general_private_subnet  = ["192.168.10.0/27", "192.168.11.0/27"]
vpc_general_public_subnet   = ["192.168.12.0/27", "192.168.13.0/27"]

db_name = "tiptondb"
env_name   = "dev"

# Security Groups
ssh_pub_ip_list = ["212.36.33.110/32"] # My IP Address to test ssh
rdp_pub_ip_list = ["212.36.33.110/32"] # My IP Address to test ssh


domain_name = "appstaging.thetiptondigital.com"

# EC2 variables
instance_type_windows_bastion = "t2.micro"
instance_type_api_svr = "t2.micro"
instance_type_linux_bastion = "t2.micro"
instance_type_rpa-agt_svr = "t2.micro"
instance_type_rpa_svr = "t2.micro"
instance_keypair = "tipton_staging_key"
bastion_private_instance_count = 1
