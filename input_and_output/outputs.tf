output "nginx_public_ip" {
    value = aws_instance.nginx1.public_ip
}

output "nginx_public_dns" {
    value = aws_instance.nginx1.public_dns
}