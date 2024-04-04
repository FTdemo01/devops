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
        
        stage('SSH') {
            steps {
                script {
                    sshagent(['ssh-agent']) {
                        // some block
                    

                    
                        // Execute SSH commands within this block
                        sh 'ssh -tt -o StrictHostKeyChecking=no ec2-user@35.91.172.141 ls'

                    }
                }
            }
        }
        
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
                    sh "pwd"
                    sh "ls -l"
                    sh 'docker-compose -f docker-composer.yaml up -d'
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