variable "env_name" {type = string}

variable "instance_keypair" {
  description = "AWS EC2 key pair required to be associated with EC2 instance"
  type = string
}

variable "domain_name" {}
variable "db_name" {}