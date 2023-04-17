pipeline {
    agent any
    stages {
        stage('Deploy to S3') {
            steps {
                git url:'https://github.com/VladislavShevchukNure/lab1.git', branch: "main"
                 sh 'pwd'
                 sh 'ls -la'
               sh "aws s3 cp index.html s3://jenkins-bucket-shevchuk"
            }
        }
    }
}
