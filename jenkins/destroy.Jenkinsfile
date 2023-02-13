pipeline {
    agent {
        label('terraform')
    }
     environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') 
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key') 
    }
    stages {
        stage('destroy') {
            steps {
                dir('terraform') {
                    sh '''#!/bin/bash
                        if [ $BRANCH_NAME == 'main' ]; then
                            echo "Terraform destroy in production & development"
                            terraform init -backend-config=./pro/pro.tfbackend
                            terraform destroy -auto-approve

                            terraform init -backend-config=./dev/dev.tfbackend -reconfigure
                            terraform destroy -auto-approve

                        else
                            echo "Terraform destroy in development"
                            
                            terraform init -backend-config=./dev/dev.tfbackend
                            terraform destroy -auto-approve
                        
                        fi   
                    ''' 
                }
            }
        }
    }
}