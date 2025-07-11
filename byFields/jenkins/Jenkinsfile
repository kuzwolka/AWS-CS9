pipeline {
    agent any

    stages {
        stage('checkout') { // clone git repo
            steps {
                git branch: 'master',
                credentialsId: 'github_access_token',
                url: 'https://github.com/kuzwolka/aws9argocd.git'
            }
        }
        stage('build') {
            steps {
                sh '''
                kubectl apply -f test.yml
                '''
            }
        }
    }
}