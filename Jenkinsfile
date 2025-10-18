pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key')    // Add in Jenkins Credentials
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')    // Add in Jenkins Credentials
    AWS_DEFAULT_REGION    = 'eu-west-3'
    SSH_PRIVATE_KEY_PATH  = '/var/jenkins_home/.ssh/id_rsa'  // مكان المفتاح الخاص داخل Jenkins
    TF_WORKDIR            = 'terraform'
    ANSIBLE_DIR           = 'ansible'
    IMAGE_NAME            = 'megodevops/my-test:latest'
  }

  stages {
    stage('Checkout SCM') {
      steps {
        echo "Cloning repository..."
        git branch: 'main', url: 'https://github.com/mego0700/my-First-project.git', credentialsId: 'cc2d68e0-ced5-4e5e-b9f8-45e83649231d'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir("${TF_WORKDIR}") {
          echo 'Initializing Terraform...'
          sh 'terraform init -input=false'
          echo 'Applying Terraform...'
          sh 'terraform apply -auto-approve -input=false'
          echo 'Getting Terraform output (public_ip)...'
          sh 'terraform output -raw public_ip > ../ansible/inventory.ini'
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        dir("${ANSIBLE_DIR}") {
          echo 'Running Ansible playbook...'
          // Ensure private key file has correct permissions
          sh "chmod 600 ${SSH_PRIVATE_KEY_PATH} || true"
          sh "ansible-playbook -i inventory.ini playbook.yml --user ubuntu --private-key ${SSH_PRIVATE_KEY_PATH} -vvvv"
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline finished: SUCCESS"
    }
    failure {
      echo "Pipeline finished: FAILURE"
    }
    always {
      echo "Done"
    }
  }
}
