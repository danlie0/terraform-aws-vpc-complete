  data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04*"]
  }
  owners = ["899922192574"] # Tipton Staging
}


data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["windows_2016_image"]
  }
  owners = ["899922192574"]
}