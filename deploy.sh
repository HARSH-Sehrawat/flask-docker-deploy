#!/usr/bin/env bash

# exit on error
set -e 

log () {
	echo -e "\033[1,32m[INFO] $1\033\[0m"
}

error_exit() {
	echo -e "\033[1;31m[ERROR] $1\033[0m" >&2
	exit 1
}

log "Updating system package"
sudo apt update -y || error_exit "Failed package update"
sudo apt upgrade -y || error_exit "Filaed package upgrade"

log "Installing Docker..."
sudo apt install -y docker.io || error_exit "Failed to install Docker"
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

log "Installing Git..."
sudo apt install -y git || error_exit "Failed to install Git"

log "Cloning Flask app repo..."
cd /home/ubuntu || error_exit "Failed to change directory"
rm -rf flask-app || true
git clone https://github.com/HARSH-Sehrawat/flask-docker-deploy.git flask-app || error_exit "Git clone failed"

cd flask-app || error_exit "Directory not found"

log "Building Docker image..."
docker build -t flask-app-image . || error_exit "Docker build failed"

log "Stopping any existing container..."
docker rm -f flask-app-container || true

log "Running container..."
docker run -d -p 5000:5000 --name flask-app-container flask-app-image || error_exit "Container failed to start"

log "Deployment successful. App running on port 5000!"
