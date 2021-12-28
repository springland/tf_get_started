## aws_elb_service_account

data "aws_elb_service_account" "root" {}

#aws_lb
resource "aws_lb" "app_lb" {
  name               = "app-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
  enable_deletion_protection = false

  access_logs {
    bucket  =  module.s3_module.s3_bucket.bucket  #aws_s3_bucket.s3_bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }
  tags = local.common_tags

}


#aws_lb_target_group

resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
#aws_lb_listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

#aws_lib_target_group_attachment
resource "aws_lb_target_group_attachment" "alb_tg_attachment_nginx" {

  count = var.subnet_count
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.nginx_servers[count.index].id
  port             = 80
}

