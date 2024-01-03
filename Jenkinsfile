pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: "Automatically run apply after generating plan?")
    }
    tools {
        git 'Default'
    }
    environment {
        AWS_ACCESS_KEY_ID      = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY  = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION     = 'us-west-2'
        GIT_CREDENTIALS        = credentials('Git')
        TERRAFORM_PATH         = '/usr/local/bin/terraform'
        WORKSPACE              = '/var/lib/jenkins/workspace/terraform-dp'
        
    }

    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: 'https://github.com/nitukumarii/Terraform_EKS_Jenkns.git', credentialsId: GIT_CREDENTIALS]]])
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir("${WORKSPACE}/Terraform_EKS_Jenkns") {
                        sh "${/usr/local/bin/terraform} init"
                        sh "${/usr/local/bin/terraform} plan -out tfplan"
                        sh "${/usr/local/bin/terraform} show -no-color tfplan > tfplan.txt"
                    }
                }
            }
        }

        stage('Approval') {
            when {
                expression { params.autoApprove == false }
            }
            steps {
                script {
                    def plan = readFile('Terraform_EKS_Jenkns/tfplan.txt')
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir("Terraform_EKS_Jenkns") {
                        sh '/usr/local/bin/terraform apply -input=false tfplan'
                    }
                }
            }
        }
    }
}
