pipeline {
     
    tools {
        git 'Default'
    }

    environment{
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
    }
}