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
echo '<html><body><h1> Welcome to Terraform  Server 1 !!! </h1></body></html>' > /usr/share/nginx/html/index.html

EOF
}


resource "aws_instance" "nginx2" {
    ami = nonsensitive(data.aws_ssm_parameter.ami.value)
    instance_type =  var.nginx_instance_type
    subnet_id = aws_subnet.subnet2.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    tags = local.common_tags
    user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><body><h1> Welcome to Terraform  Server2 !!! </h1></body></html>' > /usr/share/nginx/html/index.html

EOF
}