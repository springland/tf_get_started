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

# Networking
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags                 = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet" "subnets" {

  count = var.subnet_count

  cidr_block              = cidrsubnet(var.vpc_cidr_block , 8 , count.index)   # var.subnet_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags                    = local.common_tags
}


#Routing
resource "aws_route_table" "rtb_app_server" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.rtb_route_cidr_block
    gateway_id = aws_internet_gateway.igw.id

  }
  tags = local.common_tags
}


resource "aws_route_table_association" "rta_subnets" {
  count = var.subnet_count

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtb_app_server.id
}



#Security Group
#Nginx
resource "aws_security_group" "nginx-sg" {
  name   = "nginx-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
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
  vpc_id = aws_vpc.vpc.id

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
