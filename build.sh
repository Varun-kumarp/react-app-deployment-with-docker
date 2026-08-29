#!/bin/bash

set -e

# Login to Docker Hub
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Stop and remove old container if it exists
docker stop react || true
docker rm react || true

# Build image
docker build --no-cache -t react-cicd:latest .

# Run container	
docker run -d -it --name react -p 80:80 react-cicd:latest

# Tag for Docker Hub
docker tag react-cicd:latest varun7560/react-cicd:v${BUILD_NUMBER}

# Push to Docker Hub
docker push varun7560/react-cicd:v${BUILD_NUMBER}

echo "============= Depolyment Completed =========="
echo  "React version Deployed: v${BUILD_NUMBER}"

docker ps
