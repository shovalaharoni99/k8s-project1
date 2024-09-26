pipeline {
    environment {
        imagename = "315234377/consumer"
        dockerImage = ''
        containerName = 'my-container'
        dockerHubCredentials = 'dockerhub-cred'
    }

    agent any

    stages {
        stage('Cloning Git') {
            steps {
                git([url: 'https://github.com/shovalaharoni99/k8s-project1', branch: 'master'])
            }
        }

        stage('Building consumer image') {
            steps {
                script {
                    dockerImage = docker.build("${imagename}:latest", "consumer/")
                }
            }
        }

        stage('Running consumer image') {
            steps {
                script {
                    sh "docker run -d --name ${containerName} ${imagename}:latest"
                    // Perform any additional steps needed while the container is running
                }
            }
        }

        stage('Stop and Remove Consumer Container') {
            steps {
                script {
                    sh "docker stop ${containerName} || true"
                    sh "docker rm ${containerName} || true"
                }
            }
        }

        stage('Deploy Consumer Image') {
            steps {
                script {
                    // Use Jenkins credentials for Docker Hub login
                    withCredentials([usernamePassword(credentialsId: dockerHubCredentials, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"

                        // Push the image
                        sh "docker push ${imagename}:latest"
                    }
                }
            }
        }

        stage('Change to Producer Image') {
            steps {
                script {
                    imagename = "315234377/producer"
                }
            }
        }

        stage('Building producer image') {
            steps {
                script {
                    dockerImage = docker.build("${imagename}:latest", "producer/")
                }
            }
        }

        stage('Running producer image') {
            steps {
                script {
                    sh "docker run -d --name ${containerName} ${imagename}:latest"
                    // Perform any additional steps needed while the container is running
                }
            }
        }

        stage('Stop and Remove Producer Container') {
            steps {
                script {
                    sh "docker stop ${containerName} || true"
                    sh "docker rm ${containerName} || true"
                }
            }
        }

        stage('Deploy Producer Image') {
            steps {
                script {
                    // Use Jenkins credentials for Docker Hub login
                    withCredentials([usernamePassword(credentialsId: dockerHubCredentials, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"

                        // Push the image
                        sh "docker push ${imagename}:latest"
                    }
                }
            }
        }
    }
}
