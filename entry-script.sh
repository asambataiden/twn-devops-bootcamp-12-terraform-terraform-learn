#!/bin/bash
set -euxo pipefail
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user
docker run \
  --detach \
  --name nginx \
  --restart unless-stopped \
  --publish 8080:80 \
  nginx:latest