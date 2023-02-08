#!/bin/bash

# Install Docker
sudo su
curl https://releases.rancher.com/install-docker/20.10.sh | sh
usermod -aG docker ubuntu

# Install git
apt-get install git -y

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Clone application from repository
cd /home/ubuntu
git clone https://github.com/jonathanbaraldi/devops
cd devops/exercicios/app

# Build redis image
# cd redis
# docker build -t rrmontuan/redis:devops .

# Build node image
# cd ../node
# docker build -t rrmontuan/node:devops .

# Build NGINX image
# cd ../nginx
# docker build -t rrmontuan/nginx:devops .

# Install Rancher (Single Node)
docker run -d --name rancher --restart=unless-stopped -v /opt/rancher:/var/lib/rancher  -p 80:80 -p 443:443 rancher/rancher:v2.4.3
