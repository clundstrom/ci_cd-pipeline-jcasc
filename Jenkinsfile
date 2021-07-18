pipeline {
    agent any
    environment {
        COMMIT = "${GIT_COMMIT.substring(0,8)}"
    }
    stages {
        stage('Build') {
            steps {
                sh "printenv"
                echo 'Building the unit tests image.'
                sh 'docker build -f Dockerfile.test . --target unit-tests -t build-slave:unit-tests'
            }
        }
        stage('Run Tests') {
            parallel {
                stage('Unit tests') {
                    steps {
                        echo 'Running unit tests.'
                        sh "docker run \
                        --name ${COMMIT} \
                        build-slave:unit-tests"
                        echo 'Copying test results.'
                        sh "mkdir reports || echo 'folder already exists'"
                        sh "docker cp ${COMMIT}:/app/reports/result.xml ${pwd()}/reports/result.xml"
                        echo 'Remove container.'
                        sh "docker rm -f ${COMMIT} || true"
                    }
                    post {
                        always {
                            junit 'reports/*.xml'
                        }
                    }
                }
                stage('Lint tests') {
                    steps {
                        echo 'Running linting tests.'
                    }
                }
                stage('Coverage tests') {
                    steps {
                        echo 'Running coverage tests.'
                    }
                }
            }
        }
        stage('Staging') {
            when { not { tag '*'} }
            steps {
                echo 'Deploying to staging.'
            }
        }
        stage('Production') {
            when { tag 'release-*'}
            steps {
                echo 'Deploying to production.'
            }
        }
        stage('Teardown') {
            steps {
                echo 'Cleaning up artifacts.'
                sh 'rm -rf /reports'
            }
        }
    }
}
