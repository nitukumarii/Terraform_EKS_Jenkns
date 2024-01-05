pipeline {
     
    tools {
        git 'Default'
    }

    environment{
        TERRAFORM_PATH = "C:/Users/USER/Downloads/terraform.exe"
        GIT_CREDENTIALS = credentials('Git')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                script{
                    checkout([$class : 'GitSCM',
                            branches : [[name: '*/main']],
                            userRemoteConfigs : [[url:'https://github.com/nitukumarii/Terraform_EKS_Jenkns.git', credentialsId : 'GIT_CREDENTIALS']]])



                    
                }
                 
            }
        }

        stage('init')
            steps {
                script {
                    sh "$(TERRAFORM_PATH) init"
                }
            }
            
    }
}