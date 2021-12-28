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
    region = "us-west-2"
    profile = "ecs"
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
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = "true"
    tags = {
         Name = "tf_vpc"
    }
}

resource aws_internet_gateway "igw" {
    vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet"  "subnet1" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.vpc.id 
    map_public_ip_on_launch = "true"
}

#Routing
resource "aws_route_table"  "rtb" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id

    }
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
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


#Instances
resource "aws_instance" "nginx1" {
    ami = nonsensitive(data.aws_ssm_parameter.ami.value)
    instance_type =  "t2.micro"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]

    user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><body><h1> Welcome to Terraform !!! </h1></body></html>' > /usr/share/nginx/html/index.html

EOF
}