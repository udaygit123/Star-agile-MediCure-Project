pipeline {
    agent any
    stages {
        stage('Version') {
            steps {  // Tools Version Check
              sh 'java --version'
              sh 'mvn --version'
              sh 'docker --version'
              sh 'ansible --version'
              sh 'terraform version'
            }
        }
        stage('Packaging') {
            steps {  // Packaging the Project
              sh 'mvn clean package'
            }
        }
    }
}
