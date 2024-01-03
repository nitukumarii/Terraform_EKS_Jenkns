pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: "Automatically run apply after generating plan?")
    }
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('AKIAUQOHUT7LD4WJZCNB')
        AWS_SECRET_ACCESS_KEY = credentials('AJXEt0dm/RqtwjvtKufkyVf/xkAf/mGZ0oHIEd3zR')
        AWS_DEFAULT_REGION    = 'us-west-2'
    }

    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    dir("terraform") {
                        git url: "https://github.com/nitukumarii/Terraform_EKS_Jenkns.git"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir("terraform") {
                        sh 'terraform init'
                        sh 'terraform plan -out tfplan'
                        sh 'terraform show -no-color tfplan > tfplan.txt'
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
                    def plan = readFile('terraform/tfplan.txt')
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir("terraform") {
                        sh 'terraform apply -input=false tfplan'
                    }
                }
            }
        }
    }
}
