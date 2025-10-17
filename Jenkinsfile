pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📦 Cloning repository...'
                git branch: 'main', url: 'https://github.com/mego0700/my-First-project.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    echo '🚀 Initializing Terraform...'
                    sh 'terraform init'

                    echo '⚙️ Applying Terraform...'
                    sh 'terraform apply -auto-approve'

                    echo '📡 Extracting EC2 Public IP...'
                    script {
                        def ip = sh(returnStdout: true, script: "aws ec2 describe-instances --filters 'Name=tag:Name,Values=MyTerraformInstance' --query 'Reservations[*].Instances[*].PublicIpAddress' --output text").trim()
                        echo "Public IP = ${ip}"
                        writeFile file: '../ansible/inventory.ini', text: "[ec2]\n${ip}\n"
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('ansible') {
                    echo '🧩 Running Ansible...'
                    sh '''
                    ansible-playbook -i inventory.ini playbook.yml --user ubuntu --private-key ~/.ssh/id_rsa
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "✅ Pipeline Finished Successfully!"
        }
    }
}
