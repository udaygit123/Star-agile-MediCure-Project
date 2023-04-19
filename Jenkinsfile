pipeline {
    agent any
    stages {
        stage('Version') {  // Tools Version Check
            steps {  
              sh 'java --version'
              sh 'mvn --version'
              sh 'docker --version'
              sh 'ansible --version'
              sh 'terraform version'
            }
        }
        stage('Packaging') {   // Packaging the Project
            steps {  
              sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {   // Building Docker Image
            steps {  
              sh 'sudo docker build -t minimalkushal/medicure .'
            }
        }
        stage('Push Docker Image') {   // Pushing Docker Image
            steps {  
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'DockerHubPassword', usernameVariable: 'DockerHubUser')]) {
                    sh "sudo docker login -u ${env.dockerHubUser} -p ${env.DockerHubPassword}"
                    sh 'sudo docker push minimalkushal/medicure'
                }
            }
        }
        stage('Execute Terraform file') {   // Terraform file execution
            steps {  
              sh 'sudo chmod 600 Kushal.pem'
			  sh 'terraform init'
			  sh 'terraform validate'
			  sh 'terraform plan'
			  sh 'terraform apply -auto-approve'
            }
        }
    }
}
