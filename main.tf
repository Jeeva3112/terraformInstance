terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sample-ec2" {
    ami = "ami-0a0e5d9c7acc336f1"
    instance_type = "t2.micro"
    key_name = "jeeva"
    availability_zone = "us-east-1a"
    tags = {
        Name = "tf-ex"
    }
  
}
