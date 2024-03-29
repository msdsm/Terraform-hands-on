#!/bin/bash
yum install -y httpd
systemctl start httpd.service
echo "Hello AWS" > /var/www/html/index.html