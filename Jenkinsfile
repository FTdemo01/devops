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
        
        stage('deploy') {
            steps {
                script {
                    sshPublisher (
                        paramPublish: [
                            parameterName: 'ENVIRONMENT'
                        ],
                        publishers: [
                            sshPublisherDesc(
                                configName: 'ssh-test',
                                sshLabel: [
                                    label: 'bat'
                                ],
                                transfers: [
                                    sshTransfer(
                                        excludes: '',
                                        execCommand: "$deployCommand",
                                        execTimeout: sshTimeout,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+',
                                        remoteDirectory: remoteDir,
                                        remoteDirectorySDF: false,
                                        removePrefix: '',
                                        sourceFiles: '**/*'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ]
                    )
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