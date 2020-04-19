pipeline {
    agent any
    stages {
        stage("bake") {
            steps {
                dir("jenkins") {
                    sh "go build -o calculator-microservice main.go"
                    sh "packer build template.json"
                }
            }
        }
    }
}
