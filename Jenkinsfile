pipeline {
    agent any
    parameters {
        string(name: 'ENV', defaultValue: 'prod', description: 'Environment to deploy')
    }
    stages {
        stage('Echo Parameter') {
            steps {
                echo "Deploying to environment: ${params.ENV}"
            }
        }
    }
}
