
resource "aws_instance" "nginx_servers" {
  count = var.instance_count

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.nginx_instance_type
  subnet_id              = aws_subnet.subnets[(count.index%var.subnet_count)].id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  depends_on             = [aws_iam_role_policy.s3_access_policy]
  tags                   =  merge (local.common_tags , {
    Name = lower("${local.naming_perfix}-nginx-${count.index}")
  })

  iam_instance_profile = aws_iam_instance_profile.nginx_instance_profile.name
  user_data            = templatefile("${path.module}/startup_script.tpl" , {
    s3_bucket_id = aws_s3_bucket.s3_bucket.id
  }) 

}