# Flask Docker Deployment on AWS EC2

This project demonstrates how to containerize a simple Flask application with Docker and deploy it on an AWS EC2 instance using an automated bash deployment script.

---

## Project Overview

- Flask app: A minimal Python Flask web application that returns a greeting message.
- Dockerized: The app is containerized using a Dockerfile for easy deployment.
- Automated deployment: A "deploy.sh" bash script automates the entire setup on an Ubuntu EC2 instance:
  - Updates system packages
  - Installs Docker and Git
  - Adds the user to the Docker group
  - Clones the repo
  - Builds the Docker image
  - Runs the Docker container exposing port 5000
  - Restarts instance to apply Docker group changes

---

## Prerequisites

- AWS EC2 instance running Ubuntu (tested on 20.04 LTS)
- Security Group configured to allow:
  - SSH (port 22) from your IP
  - TCP port 5000 from your IP or open to public (for Flask app access)

---

## Files

- "flask-app.py": Simple Flask application
- "Dockerfile": Defines how to containerize the Flask app
- "requirement.txt": Python dependencies (Flask 3.0.2)
- "deploy.sh": Automated deployment script to set up the app on EC2

---
