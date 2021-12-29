vpc_cidr_block = {
    default = "10.0.0.0/16"
    dev = "10.0.0.0/16"

    uat = "10.1.0.0/16"
    prod = "10.2.0.0/16"

}


instance_count = {
    default = 2
    dev = 2
    uat = 4
    prod = 6

}

subnet_count = {
    default = 2
    dev = 2
    uat = 2
    prod = 3

}