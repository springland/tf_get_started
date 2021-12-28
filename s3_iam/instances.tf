resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.nginx_instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  tags                   = local.common_tags
  depends_on             = [aws_iam_role_policy.s3_access_policy]
  iam_instance_profile   = aws_iam_instance_profile.nginx_instance_profile.name
  user_data              = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/website/index1.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/website/image1.png /home/ec2-user/image.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/image.png /usr/share/nginx/html/image.png
EOF
}


resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.nginx_instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  depends_on             = [aws_iam_role_policy.s3_access_policy]
  tags                   = local.common_tags

  iam_instance_profile = aws_iam_instance_profile.nginx_instance_profile.name
  user_data            = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/website/index2.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.s3_bucket.id}/website/image2.png /home/ec2-user/image.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/image.png /usr/share/nginx/html/image.png
EOF
}