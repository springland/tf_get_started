## aws_elb_service_account

data "aws_elb_service_account" "root" {}

#aws_lb
resource "aws_lb" "app_lb" {
  name               = "app-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.s3_bucket.bucket
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
  vpc_id   = aws_vpc.vpc.id
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
resource "aws_lb_target_group_attachment" "alb_tg_attachment_nginx1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.nginx1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment_nginx2" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.nginx2.id
  port             = 80
}