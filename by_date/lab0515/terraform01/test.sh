#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo echo "hello" | sudo tee -a /var/www/html/index.html