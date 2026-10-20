
cat > Jenkinsfile <<'EOF'
pipeline {
    agent any

    options {
        timestamps()
    }

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPOSITORY = 'cloudmart'
        IMAGE_NAME = 'cloudmart'
        EKS_CLUSTER = 'cloudmart-eks'
        K8S_NAMESPACE = 'cloudmart'
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

                    aws ecr get-login-password --region "${AWS_REGION}" |
                        docker login --username AWS --password-stdin "${REGISTRY}"

                    docker tag "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        "${ECR_URI}:${BUILD_NUMBER}"
                    docker tag "${IMAGE_NAME}:${BUILD_NUMBER}" \
                        "${ECR_URI}:latest"

                    docker push "${ECR_URI}:${BUILD_NUMBER}"
                    docker push "${ECR_URI}:latest"

                    echo "Pushed ${ECR_URI}:${BUILD_NUMBER}"
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    set -eu

                    ACCOUNT_ID=$(aws sts get-caller-identity \
                        --query Account --output text)
                    ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"

                    aws eks update-kubeconfig \
                        --name "${EKS_CLUSTER}" \
                        --region "${AWS_REGION}"

                    kubectl set image \
                        deployment/cloudmart \
                        cloudmart="${ECR_URI}:${BUILD_NUMBER}" \
                        --namespace="${K8S_NAMESPACE}"

                    kubectl rollout status \
                        deployment/cloudmart \
                        --namespace="${K8S_NAMESPACE}" \
                        --timeout=180s

                    echo "CloudMart deployed successfully to EKS."
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: CloudMart built, tested, pushed to ECR, and deployed to EKS.'
        }
        failure {
            echo 'FAILURE: Check Console Output for the failed stage.'
        }
        always {
            echo "Pipeline finished for build ${BUILD_NUMBER}."
        }
    }
}
EOF
