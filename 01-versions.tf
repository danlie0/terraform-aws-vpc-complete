terraform {
  required_version = ">= 1.1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-west-2"

}
