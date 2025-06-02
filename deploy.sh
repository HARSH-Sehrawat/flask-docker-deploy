#!/usr/bin/env bash

set -e

LOGFILE="/home/ubuntu/deploy.log"
exec > >(tee -i $LOGFILE)
exec 2>&1

log() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}

error_exit() {
  echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
  exit 1
}

log "Updating system packages..."
sudo apt update -y || error_exit "Failed to update apt"
sudo apt upgrade -y || error_exit "Failed to upgrade apt"

log "Installing Docker and Git..."
sudo apt install -y docker.io git || error_exit "Failed to install docker or git"

log "Adding user 'ubuntu' to docker group..."
sudo usermod -aG docker ubuntu || error_exit "Failed to add user to docker group"

log "Enabling and starting docker service..."
sudo systemctl enable docker
sudo systemctl start docker

log "Cloning Flask app repo..."
cd /home/ubuntu || error_exit "Failed to cd /home/ubuntu"
rm -rf flask-app || true
git clone https://github.com/HARSH-Sehrawat/flask-docker-deploy.git flask-app || error_exit "Git clone failed"

cd flask-app || error_exit "Flask app directory not found"

log "Building Docker image..."
docker build -t flask-app-image . || error_exit "Docker build failed"

log "Stopping existing container (if any)..."
docker rm -f flask-app-container || true

log "Running Flask app container with restart policy..."
docker run -d -p 5000:5000 --restart always --name flask-app-container flask-app-image || error_exit "Failed to start container"

log "Deployment complete! Container is running."


