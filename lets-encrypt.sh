#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install software-properties-common
sudo add-apt-repository universe -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get -y update
sudo apt-get -y install certbot python3-certbot-nginx
# sudo certbot certonly --nginx
# sudo certbot --nginx