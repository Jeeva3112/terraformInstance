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

#vpc

resource "aws_vpc" "sample" {
   cidr_block = "12.0.0.0/16"
   tags = {
        Name = "demo-vpc"
    }
}

#subnet creation
resource "aws_subnet" "demo_pub" {
 vpc_id = aws_vpc.sample.id
 cidr_block = "12.1.0.0/18"
 tags = {
  Name = "demo-pub-sunet"
 }
}

 resource "aws_subnet" "demo_pri" {
 vpc_id = aws_vpc.sample.id
 cidr_block = "12.10.64.0/20"
 tags = {
  Name = "demo-pri-subnet"
 }

}
#internetgateway creation
resource "aws_internet_gateway" "demoig" {
  vpc_id = aws_vpc.sample.id
  tags = {
    Name = "demo_ig"
  }

}

#routetable creation
resource "aws_route_table" "demo_pubrt" {
  vpc_id = aws_vpc.sample.id
  
  
}

#Defining routes 

resource "aws_route" "routedefpub" {
  route_table_id = aws_route_table.demo_pubrt.id
  gateway_id = aws_internet_gateway.demoig.id
  destination_cidr_block = "0.0.0.0/0"
}

#subnet associaton

resource "aws_route_table_association" "pubrtassc" {
  subnet_id = aws_subnet.demo_pub.id
  route_table_id = aws_route_table.demo_pubrt.id
  
}

#private route table
resource "aws_route_table" "demo_prirt" {
  vpc_id = aws_vpc.sample.id
  
}

#elastic ip creation

resource "aws_eip" "demoeip" {
  domain = "vpc"
  
}

#natgateway creation

resource "aws_nat_gateway" "demo_natgw" {
  subnet_id = aws_subnet.demo_pri.id
  allocation_id = aws_eip.demoeip.id

  tags = {
    Name ="demo_eip"
  }

  
}

#private 
#Defining routes

resource "aws_route" "routedefpri" {

  route_table_id = aws_route_table.demo_prirt.id
  gateway_id = aws_nat_gateway.demo_natgw.id
  destination_cidr_block = "0.0.0.0/0"
  
}

#private subnet association

resource "aws_route_table_association" "prirtassc" {
  route_table_id = aws_route_table.demo_prirt.id
  subnet_id = aws_subnet.demo_pri.id
 
  
}