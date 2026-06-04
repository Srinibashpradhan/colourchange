pipeline {
    agent any

    environment {
        // Replace with your dedicated Harbor Server IP address
        HARBOR_REGISTRY = "YOUR_HARBOR_SERVER_IP" 
        PROJECT_NAME    = "sandbox"
        IMAGE_NAME      = "my-test-app"
        IMAGE_TAG       = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // This step automatically checks out whichever GitHub repo is configured in the UI
                checkout scm
                echo 'Source code successfully retrieved from GitHub.'
            }
        }

        stage('Kaniko Build & Push') {
            steps {
                echo "Spinning up isolated Kaniko container..."
                
                sh """
                docker run --rm \
                  -v \${WORKSPACE}:/workspace \
                  -v /var/lib/jenkins/.docker/config.json:/kaniko/.docker/config.json:ro \
                  gcr.io/kaniko-project/executor:latest \
                  --dockerfile=/workspace/Dockerfile \
                  --context=dir:///workspace \
                  --destination=${HARBOR_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG} \
                  --insecure \
                  --insecure-pull
                """
            }
        }
    }
}
