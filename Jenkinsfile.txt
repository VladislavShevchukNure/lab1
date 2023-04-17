pipeline {
    agent any
    stages {
        stage('Deploy to S3') {
            steps {
                git 'https://github.com/VladislavShevchukNure/lab1.git'
                
               // sh "aws s3 cp index.html s3://jenkins-bucket-shevchuk"
            }
        }
    }
}
