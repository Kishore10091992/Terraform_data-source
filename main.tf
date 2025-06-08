terraform {
 cloud {
  organization = "1st_Terraform_cloud"

  workspace {
   name = "Data_Source"
  }
 }

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

data "aws_subnet" "Exist_subnet" {
 id = "subnet-0e002c3dc85ba7f1d"
}

data "aws_security_group" "Exist_sg" {
 id ="sg-02a9db5a3c6df8356"
}

data "aws_key_pair" "Exist_keypair" {
 key_name = "Terraform_ec2"
}

data "aws_ami" "latest_amazon_linux" {
 most_recent = true
 owners = ["amazon"]

 filter {
  name = "name"
  values = ["amzn2-ami-hvm-*"]
 }
}

resource "aws_network_interface" "data_ec2_nt_intf" {
 subnet_id = data.aws_subnet.Exist_subnet.id
 security_groups = [data.aws_security_group.Exist_sg.id]
}

resource "aws_instance" "data_ec2" {
 ami = data.aws_ami.latest_amazon_linux.id
 instance_type = var.instance_type
 key_name = data.aws_key_pair.Exist_keypair.key_name

 network_interface {
  device_index = 0
  network_interface_id = aws_network_interface.data_ec2_nt_intf.id 
  }

 tags = {
  Name = "data_ec2"
 }
}