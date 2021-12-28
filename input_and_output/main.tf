##############################################################
# Terraform
##############################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }  
}

##########################################################
#  Provider
###########################################################


provider "aws" {
    region = var.region
    profile = var.profile
}


##############################################################
# DATA
###############################################################

data "aws_ssm_parameter" "ami" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

################################################################
# Resources
#################################################################

# Networking
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = var.vpc_enable_dns_hostnames
    tags = local.common_tags
}

resource aws_internet_gateway "igw" {
    vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet"  "subnet1" {
    cidr_block = var.subnet1_cidr_block
    vpc_id = aws_vpc.vpc.id 
    map_public_ip_on_launch = var.subnet1_map_public_ip_on_launch
    tags = local.common_tags
}

#Routing
resource "aws_route_table"  "rtb" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = var.rtb_route_cidr_block
        gateway_id = aws_internet_gateway.igw.id

    }
    tags = local.common_tags
}
 
resource "aws_route_table_association" "rta_subnet1" {
    subnet_id =  aws_subnet.subnet1.id
    route_table_id = aws_route_table.rtb.id
} 

#Security Group
#Nginx
resource "aws_security_group" "nginx-sg" {
    name = "nginx-sg"
    vpc_id =  aws_vpc.vpc.id

    ingress {
        from_port =  80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [var.ngnix_sg_cidr_block]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.ngnix_sg_cidr_block]
    }

    tags = local.common_tags
}


#Instances
resource "aws_instance" "nginx1" {
    ami = nonsensitive(data.aws_ssm_parameter.ami.value)
    instance_type =  var.nginx_instance_type
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    tags = local.common_tags
    user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><body><h1> Welcome to Terraform !!! </h1></body></html>' > /usr/share/nginx/html/index.html

EOF
}