def sshTimeout = 960000
def deployCommand = """mkdir -p /tmp/deploy
  cd /tmp/deploy
  chmod +x ./deploy.sh
  ./deploy.sh
"""
def remoteDir = "/tmp/deploy"

pipeline {
    agent any
    
    parameters {
        choice(
            name: 'ENVIRONMENT',
            description: 'Environment to deploy',
            choices: ['dev1', 'dev2', 'prod']
        )
        booleanParam(
            name: 'DEPLOY_3RD',
            defaultValue: false,
            description: 'When selected, following containers will be updated: haproxy, elasticsearch, mongo, logstash, serviceapi, rabbit, eureka, msap-prototype, screening, reporting, gateway, admin'
        )
    }
    
    stages {
        stage('Checkout') {
            steps {
                sh 'git clone --branch main-docker https://github.com/FTdemo01/contacts.app.api-testing.git'
                sleep(30)
            }
        }
        
        
        
        stage('Deploy') {
            when {
                expression { params.ENVIRONMENT && params.DEPLOY_3RD }
            }
            steps {
                script {
                    sh 'docker-compose -f docker-compose.yaml up -d'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed!'
        }
        always {
            cleanWs()
        }
    }
}