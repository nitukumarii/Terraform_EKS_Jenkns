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
        TERRAFORM_PATH         = 'terraform' // Assuming Terraform is in the system PATH
        WORKSPACE              = "${WORKSPACE}/terraform-jenkins/Terraform_EKS_Jenkns"
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

        stage('Check Terraform Config') {
            steps {
                script {
                    def terraformConfigPath = "${WORKSPACE}/main.tf"
                    if (!fileExists(terraformConfigPath)) {
                        error "Terraform configuration file not found at: ${terraformConfigPath}"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir(WORKSPACE) {
                        sh "${TERRAFORM_PATH} init"
                        sh "${TERRAFORM_PATH} plan -out tfplan"
                        sh "${TERRAFORM_PATH} show -no-color tfplan > tfplan.txt"
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
                    def plan = readFile('tfplan.txt')
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir(WORKSPACE) {
                        sh "${TERRAFORM_PATH} apply -input=false tfplan"
                    }
                }
            }
        }
    }
}
