pipeline {
    agent any

    environment {
        TF_NODE_IP   = "172.31.19.146"    // Terraform node private/public IP
        TF_NODE_USER = "ec2-user"
        TF_REPO      = "https://github.com/sandy301999/Real-Prj.git"
    }

    stages {
        stage('Terraform Init') {
            steps {
                sshagent (credentials: ['tf-node-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${TF_NODE_USER}@${TF_NODE_IP} "
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
                sshagent (credentials: ['tf-node-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${TF_NODE_USER}@${TF_NODE_IP} "
                          cd ~/terraform && \
                          terraform plan -out=tfplan
                        "
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sshagent (credentials: ['tf-node-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ${TF_NODE_USER}@${TF_NODE_IP} "
                          cd ~/terraform && \
                          terraform apply -auto-approve tfplan
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform pipeline completed successfully!"
        }
        failure {
            echo "❌ Terraform pipeline failed. Check logs."
        }
    }
}
