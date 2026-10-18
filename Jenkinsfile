
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPOSITORY = 'cloudmart'
        IMAGE_NAME = 'cloudmart'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Building CloudMart-CICD'
                sh 'pwd && ls -la'
            }
        }

        stage('Validate Application Files') {
            steps {
                sh '''
                    set -eu
                    test -f app/package.json
                    test -f app/server.js
                    test -f app/server.test.js
                    test -f app/Dockerfile
                    test -f app/public/index.html
                    echo "Application files validated."
                '''
            }
        }

        stage('Test Application') {
            steps {
                dir('app') {
                    sh '''
                        set -eu

                        docker run --rm \
                            --user "$(id -u):$(id -g)" \
                            -e npm_config_cache=/tmp/npm-cache \
                            -v "$PWD:/app" \
                            -w /app \
                            node:20-alpine \
                            sh -c 'node --version && npm install && npm test'
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu
                    docker build \
                        -t "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        -t "${IMAGE_NAME}:latest" \
                        ./app
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh '''
                    set -eu
                    docker image inspect "${IMAGE_NAME}:${BUILD_NUMBER}"
                    docker image ls "${IMAGE_NAME}"
                '''
            }
        }

        stage('Push Image to Amazon ECR') {
            steps {
                sh '''
                    set -eu

                    ACCOUNT_ID=$(aws sts get-caller-identity \
                        --query Account --output text)

                    REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
                    ECR_URI="${REGISTRY}/${ECR_REPOSITORY}"

                    aws ecr get-login-password \
                        --region "${AWS_REGION}" |
                        docker login \
                            --username AWS \
                            --password-stdin "${REGISTRY}"

                    docker tag "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        "${ECR_URI}:${BUILD_NUMBER}"

                    docker tag "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        "${ECR_URI}:latest"

                    docker push "${ECR_URI}:${BUILD_NUMBER}"
                    docker push "${ECR_URI}:latest"

                    echo "CloudMart image pushed successfully."
                    echo "Image: ${ECR_URI}:${BUILD_NUMBER}"
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: CloudMart-CICD pipeline completed.'
        }

        failure {
            echo 'FAILURE: Check Console Output for the failed stage.'
        }

        always {
            echo "Pipeline finished for build ${BUILD_NUMBER}."
        }
    }
}
