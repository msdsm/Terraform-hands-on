output "publicIp" {
  value = aws_instance.myweb.public_ip
}

output "url" {
  value = "${aws_instance.myweb.public_ip}/index.html"
}
