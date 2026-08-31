pipeline {
    agent any

    environment {
        IMAGE_NAME = 'varun7560/react-cicd'
        IMAGE_TAG  = "v${BUILD_NUMBER}"
        FULL_IMAGE = "${IMAGE_NAME}:v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
         }

        stage('Change File Permission') {
            steps {
                echo 'Giving execute permission to build.sh...'
                sh 'chmod +x build.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${FULL_IMAGE}"

                sh './build.sh build'
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                echo "Scanning Docker image for HIGH and CRITICAL vulnerabilities... : ${FULL_IMAGE}"

                sh '''
                    trivy image \
                    --severity HIGH,CRITICAL \
                    --exit-code 1 \
                    --no-progress \
                    ${FULL_IMAGE}
                '''
            }
        }

        stage('Docker Hub Login') {
            steps {
                echo 'Logging in to Docker Hub...'

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "Pushing ${FULL_IMAGE} to Docker Hub..."

                sh './build.sh push'
            }
        }

        stage('Deploy React Application') {
            steps {
                echo "Deploying React application."

                sh './build.sh deploy'
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Checking running Docker containers.'

                sh '''
                    echo "=========================================="
                    echo "Running Containers"
                    echo "=========================================="

                    docker ps

                    echo "=========================================="
                    echo "React Application"
                    echo "=========================================="

                    docker ps --filter "name=react"
                '''
            }
        }
    }

    post {
        success {
            echo """
            ==========================================
            CI/CD PIPELINE SUCCESSFUL
            ==========================================
            React Image : ${FULL_IMAGE}
            Docker Hub  : ${IMAGE_NAME}:v${BUILD_NUMBER}
            Status      : DEPLOYED
            ==========================================
            """
        }

        failure {
            echo """
            ==========================================
            CI/CD PIPELINE FAILED
            ==========================================
            Check the Jenkins console output.
            ==========================================
            """
        }

        always {
            sh 'docker logout || true'
        }
    }
}
