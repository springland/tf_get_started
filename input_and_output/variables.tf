variable env {
    default = "dev"
    type = string
    description = " resource environment dev/uat/prod"
    sensitive = false
}

variable region {
    default = "us-west-2"
    type = string
    description = " AWS Region"
    sensitive = false
}

variable profile {
    default = "ecs"
    type = string
    description = "AWS CLI connection profile"
    sensitive = false
}

variable password {
    type = string 
    description = "dummy password"
    sensitive = true
}


variable  vpc_cidr_block {
    type = string
    default = "10.0.0.0/16"
  
}

variable vpc_enable_dns_hostnames {
    type = bool
    default = true
}

variable subnet1_cidr_block {
    type = string
    default = "10.0.0.0/24"
}

variable subnet1_map_public_ip_on_launch {
    type = bool
    default = true
}

variable rtb_route_cidr_block {
    type = string
    default = "0.0.0.0/0"
}

variable ngnix_sg_cidr_block {
    type = string
    default = "0.0.0.0/0"

}

variable nginx_instance_type {
    type = string
    default = "t2.micro"
}


variable company {
    type = string
    default = "springland"
}