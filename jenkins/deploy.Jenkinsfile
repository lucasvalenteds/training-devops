pipeline {
    agent any
    environment {
        IMAGE = "calculator-microservice"
    }
    stages {
        stage("clean") {
            steps {
                dir("jenkins") {
                    sh "sh cleanup.sh"
                }
            }
        }
        stage("deploy") {
            steps {
                dir("jenkins") {
                    sh "docker run --rm --detach -p 8080:8080 --name $IMAGE $IMAGE"
                }
            }
        }
    }
}

