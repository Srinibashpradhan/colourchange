pipeline {
    agent any

    environment {
        // Your exact Harbor Server IP
        HARBOR_REGISTRY = "35.154.27.201" 
        PROJECT_NAME    = "sandbox"
        IMAGE_NAME      = "my-test-app"
        IMAGE_TAG       = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                echo 'Source code successfully retrieved from GitHub.'
            }
        }

        stage('Kaniko Build & Push') {
            steps {
                echo "Building image and pushing to Harbor..."
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

        // --- NEW CONTINUOUS DEPLOYMENT STAGE ---
        stage('Deploy to EC2') {
            steps {
                echo "Deploying the latest image to the live server..."
                
                sh """
                # 1. Pull the absolute newest image from Harbor (prevents caching old versions)
                docker pull ${HARBOR_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG}
                
                # 2. Stop and delete the old container (the '|| true' prevents the pipeline from failing on the very first run when no container exists yet)
                docker stop my-live-website || true
                docker rm my-live-website || true
                
                # 3. Start the brand new container and map it to port 80
                docker run -d --name my-live-website -p 80:80 ${HARBOR_REGISTRY}/${PROJECT_NAME}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }
    }
}
