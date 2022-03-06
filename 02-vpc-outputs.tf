# SECURE VPC OUTPUTS

output "secure_vpc_id" {
  description = "The CIDR block of the VPC"
  value       = module.dev-secure_vpc.vpc_id
}


output "secure_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.dev-secure_vpc.vpc_cidr_block
}

output "secure_vpc_azs" {
  description = "availability zones"
  value       = module.dev-secure_vpc.azs
}

# VPC public subnets
output "secure_vpc_public_subnets" {
  description = "List of IDs of public subnets" 
  value = module.dev-secure_vpc.public_subnets
}

# GENERAL VPC OUTPUTS

output "general_vpc_id" {
  description = "The CIDR block of the VPC"
  value       = module.dev-general-vpc.vpc_id
}

output "general_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.dev-general-vpc.vpc_cidr_block
}

output "general_vpc_azs" {
  description = "availability zones"
  value       = module.dev-general-vpc.azs
}

# general VPC public subnets
output "general_vpc_public_subnets" {
  description = "List of IDs of public subnets" 
  value = module.dev-general-vpc.public_subnets
}