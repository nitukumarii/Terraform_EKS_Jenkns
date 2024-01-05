pipeline {
     
    tools {
        git 'Default'
    }

    environment{
        TERRAFORM_PATH = "/usr/bin"
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
                    sh "${TERRAFORM_PATH} init"
                }
            }



        }
            
            
    }
}