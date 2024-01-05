pipeline {
    agent any 

    credentials{
        GIT_CREDENTIALS = credentials('Git')
    }



    stages {
        stage('checkout') {
            steps {
                script{
                    checkout([$class : 'GitSCM',
                            branches : [[name: '*/main']],
                            userRemoteConfigs : [[url:'https://github.com/nitukumarii/Terraform_EKS_Jenkns.git' credentialsId : 'GIT_CREDENTIALS']]])



                    
                }
                 
            }
        }
    }
}