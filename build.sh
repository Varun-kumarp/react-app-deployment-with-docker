#!/bin/bash

set -e

# Login to Docker Hub
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Stop and remove old container if it exists
docker stop react || true
docker rm react || true

# Build image
docker build -t react-deployment:latest .

# Tag for Docker Hub
docker tag react-deployment:latest varun7560/react-deployment:latest

# Push to Docker Hub
docker push varun7560/react-deployment:latest

# Run container
docker run -d --name react -p 8081:80 react-deployment:latest

