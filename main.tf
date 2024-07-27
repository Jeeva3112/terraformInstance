terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
}
resource "aws_instance" "sample" {
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  
}