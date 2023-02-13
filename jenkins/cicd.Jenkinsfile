pipeline {
    agent {
        label('terraform')
    }
     environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') 
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key') 
    }
    stages {
        stage('init') {
            steps {
                dir('terraform') {
                    sh '''#!/bin/bash
                        if [ $BRANCH_NAME == 'main' ]; then
                            echo "Terraform init in production"
                            terraform init -backend-config=./pro/pro.tfbackend
                        else
                            echo "Terraform init in development"
                            terraform init -backend-config=./dev/dev.tfbackend
                        fi   
                    ''' 
                }
            }
        }
         stage('plan') {
            steps {
                dir('terraform') {
                    sh '''#!/bin/bash
                        if [ $BRANCH_NAME == 'main' ]; then
                            echo "Terraform plan in production"
                            terraform plan -var-file=./pro/pro.tfvars 
                        else
                            echo "Terraform plan in development"
                            terraform plan -var-file=./dev/dev.tfvars 
                        fi   
                    ''' 
                }
            }
        }

        stage('Main input') {
            when {
                branch 'main'
            }

            steps {
                input(message: "Do you want to continue", ok: "Yes, continue the pipeline")
            } 
        }
        
        stage('apply') {  
            steps {
                dir('terraform') {

                    sh '''#!/bin/bash
                        if [ $BRANCH_NAME == 'main' ]; then
                            echo "Terraform apply in production"
                            terraform apply -var-file=./pro/pro.tfvars -auto-approve
                        else
                            echo "Terraform apply in development"
                            terraform apply -var-file=./dev/dev.tfvars -auto-approve
                        fi
                    '''            
                }
            }
        }
    }
}