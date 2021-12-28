output "nginx_public_ip" {
  value = aws_instance.nginx_servers[*].public_ip
}

output "nginx_public_dns" {
  value = aws_instance.nginx_servers[*].public_dns
}

output "app_lb_ip" {
  value = aws_lb.app_lb.dns_name
}