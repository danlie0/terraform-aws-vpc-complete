
# Create Secure VPC
module "dev-secure_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"


  name = var.vpc_secure_name
  cidr = var.vpc_secure_cidr_block

  enable_dns_support     = true
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  propagate_private_route_tables_vgw = true

  azs             = var.availability_zones
  private_subnets = var.vpc_secure_private_subnet
  public_subnets  = var.vpc_secure_public_subnet

  private_subnet_tags = local.common_tags
  public_subnet_tags = local.common_tags

  vpc_tags = {
    Name = "vpc-secure-${var.env_name}"
  }
}

################################################################################
# VPC Module to Create General VPC
################################################################################


module "dev-general-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"


  name = var.vpc_general_name
  cidr = var.vpc_general_cidr_block

  enable_dns_support     = true
  enable_dns_hostnames    = true
  enable_nat_gateway     = true
  enable_vpn_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  

  azs             = var.availability_zones_general
  private_subnets = var.vpc_general_private_subnet
  public_subnets  = var.vpc_general_public_subnet

  private_subnet_tags = local.common_tags
  public_subnet_tags = local.common_tags

  vpc_tags = {
    Name = "vpc-general-${var.env_name}"
  }

}

################################################################################
# Create VPC Peering Connection
################################################################################


resource "aws_vpc_peering_connection" "vpc_peer_connection" {
  accepter {
    allow_classic_link_to_remote_vpc = "false"
    allow_remote_vpc_dns_resolution  = "false"
    allow_vpc_to_remote_classic_link = "false"
  }

  peer_vpc_id = module.dev-general-vpc.vpc_id
  auto_accept = "true"

  requester {
    allow_classic_link_to_remote_vpc = "false"
    allow_remote_vpc_dns_resolution  = "false"
    allow_vpc_to_remote_classic_link = "false"
  }

  tags = {
    Name = "dev secure vpc to general vpc peering connection"
  }

  vpc_id = module.dev-secure_vpc.vpc_id
}