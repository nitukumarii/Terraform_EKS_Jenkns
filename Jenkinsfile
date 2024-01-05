pipeline {
     
    tools {
        git 'Default'
    }

    environment{
        AWS_ACCESS_KEY_ID      = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY  = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION     = 'us-west-2'
        TERRAFORM_PATH = "/usr/bin"
        GIT_CREDENTIALS = credentials('Git')
        WORKSPACE              = "${WORKSPACE}"
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

        stage('Debug') {
    steps {
        script {
            sh 'echo $PATH'
        }
    }
}


        stage('init'){
            steps{
                script{
                    sh "${TERRAFORM_PATH}/terraform init"
                }
            }



        }

        stage('plan'){
            steps{
                script{
                    sh "${TERRAFORM_PATH}/terraform plan"
                }
            }



        }  

        stage('apply'){
            steps{
                script{
                    sh "${TERRAFORM_PATH}/terraform apply -auto-approve"
                }
            }
        }
            
    }
}