# Secure VPC Variables
variable "vpc_secure_name" {
    type = string
    description = "vpc name"
}


variable "vpc_secure_cidr_block" {
    type = string
    description = "Subnet cidr block"
}


variable "availability_zones" {
    type = list
    description = "list of availablity zones to use"
}


variable "vpc_secure_private_subnet" {
    type = list
    description = "list of private subnet CIDR"
}


variable "vpc_secure_public_subnet" {
    type = list
    description = "list of public subnet CIDR"
}

variable "availability_zones_general" {
    type = list
    description = "list of availablity zones to use"
}
variable "vpc_general_name" {}
variable "vpc_general_cidr_block" {}
variable "vpc_general_private_subnet" { type = list }
variable "vpc_general_public_subnet" { type = list }