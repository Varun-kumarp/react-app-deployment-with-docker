#!/bin/bash

set -e

IMAGE_NAME="varun7560/react-cicd"
IMAGE_TAG="v${BUILD_NUMBER}"
FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="react"

echo "=========================================="
echo "React CI/CD Pipeline"
echo "=========================================="
echo "Build Number : ${BUILD_NUMBER}"
echo "Image        : ${FULL_IMAGE}"
echo "=========================================="

case "$1" in

    build)

        echo "=========================================="
        echo "BUILDING DOCKER IMAGE"
        echo "=========================================="

        docker build \
            --no-cache \
            -t "${FULL_IMAGE}" \
            -t "${IMAGE_NAME}:latest" \
            .

        echo "Docker image successfully built."

        docker images | grep "react-cicd"

        ;;


    push)

        echo "=========================================="
        echo "PUSHING IMAGE TO DOCKER HUB"
        echo "=========================================="

        echo "Pushing: ${FULL_IMAGE}"

        docker push "${FULL_IMAGE}"

        echo "Updating latest tag..."

        docker push "${IMAGE_NAME}:latest"

        echo "Docker image successfully pushed."

        ;;


    deploy)

        echo "=========================================="
        echo "DEPLOYING REACT APPLICATION"
        echo "=========================================="

        echo "Stopping old container..."

        docker stop "${CONTAINER_NAME}" || true

        echo "Removing old container..."

        docker rm "${CONTAINER_NAME}" || true

        echo "Starting new React container..."

        docker run -d \
            --name "${CONTAINER_NAME}" \
            -p 80:80 \
            "${FULL_IMAGE}"

        echo "React container started."

        echo "=========================================="
        echo "DEPLOYMENT DETAILS"
        echo "=========================================="

        echo "Container : ${CONTAINER_NAME}"
        echo "Image     : ${FULL_IMAGE}"
        echo "Port      : 80"

        echo "=========================================="
        echo "RUNNING CONTAINER"
        echo "=========================================="

        docker ps --filter "name=${CONTAINER_NAME}"

        ;;


    *)

        echo "Usage:"
        echo "./build.sh build"
        echo "./build.sh push"
        echo "./build.sh deploy"

        exit 1

        ;;

esac

echo "=========================================="
echo "Operation Completed Successfully"
echo "=========================================="
