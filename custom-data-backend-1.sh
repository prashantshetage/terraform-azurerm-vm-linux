#!/bin/bash
apt get update
apt -y install nginx
sed -i 's/Welcome to nginx!/Backend 1/' /var/www/html/index.nginx-debian.html
systemctl restart nginx
systemctl enable nginx