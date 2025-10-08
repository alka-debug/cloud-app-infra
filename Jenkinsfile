pipeline {
   agent any
 
   environment {
       IMAGE_NAME = "alka2212/flask-cloud-app"
       TAG = "latest"
   }
   
   stages {
      stage('Checkout') {
        steps {
            git branch: 'main', url: 'https://github.com/alka-debug/cloud-app-infra.git'

        }
      }

 
      stage('Build Docker Image') {
         steps {
            sh 'docker build -t $IMAGE_NAME:$TAG .'
         }
      }

      stage('Push to Docker Hub') {
        steps {
         withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER' )]) {
               sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
               sh 'docker push $IMAGE_NAME:$TAG'
         }

       }
      }
      
      stage('Deploy') {
         steps {
               sh '''
               docker stop flask-app || true
               docker rm flask-app || true
               docker run -d -p 7800:7800 --name flask-app $IMAGE_NAME:$TAG
               
               '''
         }
       }
   
      stage('Provision Infrastructure (Terraform)') {
         steps {
           dir('terraform') {
              sh '''
                 /usr/local/bin/terraform init -input=false
                 /usr/local/bin/terraform plan -out=tfplan
                 /usr/local/bin/terraform destroy -auto-approve || true
                 /usr/local/bin/terraform apply -auto-approve tfplan
              
              '''
           }  
         }
      }
   }
}
