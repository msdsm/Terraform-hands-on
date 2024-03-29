output "publicIp" {
  value = aws_instance.myweb.public_ip
}

output "url" {
  value = "http://${aws_instance.myweb.public_ip}/index.html"
}
