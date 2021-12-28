variable "env" {
  default     = "dev"
  type        = string
  description = " resource environment dev/uat/prod"
  sensitive   = false
}

variable "region" {
  default     = "us-west-2"
  type        = string
  description = " AWS Region"
  sensitive   = false
}

variable "profile" {
  default     = "ecs"
  type        = string
  description = "AWS CLI connection profile"
  sensitive   = false
}

variable "password" {
  type        = string
  description = "dummy password"
  sensitive   = true
}


variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "vpc_enable_dns_hostnames" {
  type    = bool
  default = true
}

#variable "subnets_cidr_block" {
#  type = map(string)
#  default = {
#    subnet1 = "10.0.0.0/24"
#    subnet2 = "10.0.1.0/24"
#  }
#}


variable "subnet_cidr_blocks" {
  type = list(string)
  default =["10.0.0.0/24" , "10.0.1.0/24"]
}

variable "subnet_map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "rtb_route_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "app_lb_sg_cidr_block" {
  type    = string
  default = "0.0.0.0/0"

}

variable "nginx_instance_type" {
  type    = string
  default = "t2.micro"
}


variable "company" {
  type    = string
  default = "springland"
}

variable subnet_count {
  type = number
  default = 2
}

variable instance_count {
  type = number
  default = 4
}

variable naming_prefix {
  type = string
  description = "naming prefix for all of the resources"
  default = "tf-get-started"
}