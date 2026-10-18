pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        skipDefaultCheckout(true)
    }

    environment {
        IMAGE_NAME = 'cloudmart'
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'echo "Building CloudMart-CICD"'
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Validate Application Files') {
            steps {
                sh '''
                    test -f app/package.json
                    test -f app/server.js
                    test -f app/server.test.js
                    test -f app/Dockerfile
                    test -f app/public/index.html
                '''
            }
        }

        stage('Test Application') {
            steps {
                dir('app') {
                    sh 'node --version'
                    sh 'npm --version'
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                      -t ${IMAGE_NAME}:${IMAGE_TAG} \
                      -t ${IMAGE_NAME}:latest \
                      ./app
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker image inspect ${IMAGE_NAME}:${IMAGE_TAG}'
                sh 'docker images ${IMAGE_NAME}'
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: CloudMart tests passed and Docker image was built.'
        }

        failure {
            echo 'FAILURE: Review the Jenkins console output for the failed stage.'
        }

        always {
            echo "CloudMart pipeline completed for build ${BUILD_NUMBER}."
        }
    }
}


stage('Push Image to Amazon ECR') {
    steps {
        sh '''
            set -eu

            AWS_REGION="ap-south-1"
            ECR_REPOSITORY="cloudmart"
            ACCOUNT_ID=$(aws sts get-caller-identity \
                --query Account --output text)

            REGISTRY="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
            ECR_URI="${REGISTRY}/${ECR_REPOSITORY}"

            aws ecr get-login-password \
                --region "${AWS_REGION}" |
                docker login \
                    --username AWS \
                    --password-stdin "${REGISTRY}"

            docker tag "cloudmart:${BUILD_NUMBER}" \
                "${ECR_URI}:${BUILD_NUMBER}"

            docker tag "cloudmart:${BUILD_NUMBER}" \
                "${ECR_URI}:latest"

            docker push "${ECR_URI}:${BUILD_NUMBER}"
            docker push "${ECR_URI}:latest"

            echo "CloudMart image pushed successfully."
        '''
    }
}
