pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        IMAGE_NAME = 'cloudmart'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test Application') {
            steps {
                dir('app') {
                    sh 'node --version'
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t cloudmart:${BUILD_NUMBER} ./app'
            }
        }
    }

    post {
        success {
            echo 'CloudMart tests and Docker build succeeded.'
        }
        failure {
            echo 'CloudMart pipeline failed. Review the stage logs.'
        }
    }
}
