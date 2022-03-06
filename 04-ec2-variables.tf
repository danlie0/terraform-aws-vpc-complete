variable "instance_type_windows_bastion" {
  type = string
  default = "t2.micro"
}

variable "instance_type_linux_bastion" {
  type = string
  default = "t2.micro"
}

variable "instance_type_api_svr" {
  type = string
  default = "t2.micro"
}

variable "instance_type_rpa-agt_svr" {
  type = string
  default = "t2.micro"
}

variable "instance_type_rpa_svr" {
  type = string
  default = "t2.micro"
}



variable "bastion_private_instance_count" {
  description = "AWS EC2 Private Instance Count"
  type = number
  default = 1
}

