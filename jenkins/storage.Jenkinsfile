pipeline {
    agent {
        label('aws')
    }

    environment { 
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id') 
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key') 
    }

    triggers {
        cron('*/10 * * * *')
    }

    stages {
        stage('clean-buckets') {
            steps {
                sh '''#!/bin/bash
                    buckets=($(aws s3 ls s3:// --recursive | awk '{print $3}'))

                    for bucket in "${buckets[@]}"; do
                        if [[ $bucket != *"tfstate"* ]]; then
                            echo "Bucket: $bucket"
                            objects=$(aws s3api list-objects --bucket $bucket)
                            echo "Objects: $objects"
                            if [[ $objects != "" ]]; then
                                size=$(aws s3api list-objects --bucket $bucket --output json --query "sum(Contents[].Size)")
                                size=$(($size / 1048576))
                                if [[ size -gt 20 ]]; then
                                    echo "Deleting objects from the bucket $bucket"
                                    aws s3 rm --recursive s3://$bucket
                                fi
                            fi
                        else
                            echo "Bucket tftstate $bucket, skipping..."
                        fi
                    done
                    '''
            }
        }
    }
}