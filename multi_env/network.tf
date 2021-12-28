##############################################################
# DATA
###############################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "available" {
  state = "available"
}
################################################################
# Resources
#################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_block[terraform.workspace]

  azs = slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace]) #["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = [for s in range(var.subnet_count[terraform.workspace]) : cidrsubnet(var.vpc_cidr_block[terraform.workspace], 8, s)] #["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames    = var.vpc_enable_dns_hostnames
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = local.common_tags
}





#Security Group
#Nginx
resource "aws_security_group" "nginx-sg" {
  name   = "nginx-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block[terraform.workspace]]
    #security_groups = [aws_security_group.app_lb_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.app_lb_sg]
  }

  tags = local.common_tags
}


resource "aws_security_group" "alb_sg" {
  name   = "app_lb_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.app_lb_sg_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.app_lb_sg_cidr_block]
  }

  tags = local.common_tags
}
