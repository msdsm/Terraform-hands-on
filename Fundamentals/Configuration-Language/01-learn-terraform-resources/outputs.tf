output "domain-name" {
  value = aws_instance.myweb.public_dns
}

output "application-url" {
  value = "${aws_instance.myweb.public_dns}/index.php"
}
