pipeline {
    agent any

    environment {
        TF_NODE_IP = "172.31.19.146"   // your EC2 (TF node) private/public IP
        TF_REPO    = "https://github.com/sandy301999/Real-Prj.git"
    }

    stages {
        stage('Terraform Init') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'tf-login', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@${TF_NODE_IP} "
                          rm -rf ~/terraform && \
                          git clone ${TF_REPO} ~/terraform && \
                          cd ~/terraform && \
                          terraform init
                        "
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'tf-login', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@${TF_NODE_IP} "
                          cd ~/terraform && terraform plan -out=tfplan
                        "
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'tf-login', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    sh '''
                        ssh -i $SSH_KEY -o StrictHostKeyChecking=no $SSH_USER@${TF_NODE_IP} "
                          cd ~/terraform && terraform apply -auto-approve tfplan
                        "
                    '''
                }
            }
        }
    }
}
