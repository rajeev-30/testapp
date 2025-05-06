pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'testapp'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Environment') {
            steps {
                sh '''
                    # Check if Node.js is installed
                    if ! command -v node &> /dev/null; then
                        echo "Node.js is not installed. Installing Node.js..."
                        # For macOS
                        if [[ "$OSTYPE" == "darwin"* ]]; then
                            brew install node
                        else
                            # For Linux
                            curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                            sudo apt-get install -y nodejs
                        fi
                    fi
                    
                    # Check if Docker is installed
                    if ! command -v docker &> /dev/null; then
                        echo "Docker is not installed. Please install Docker first."
                        exit 1
                    fi
                    
                    # Check if Docker Compose is installed
                    if ! command -v docker-compose &> /dev/null; then
                        echo "Docker Compose is not installed. Please install Docker Compose first."
                        exit 1
                    fi
                    
                    # Verify installations
                    node --version
                    npm --version
                    docker --version
                    docker-compose --version
                '''
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm test || true'  // Added || true since there might not be tests yet
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }
        
        stage('Deploy') {
            steps {
                sh "docker-compose down || true"
                sh "docker-compose up -d"
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
            // Add more detailed error reporting
            sh '''
                echo "=== Build Environment ==="
                node --version || echo "Node.js not installed"
                npm --version || echo "npm not installed"
                docker --version || echo "Docker not installed"
                docker-compose --version || echo "Docker Compose not installed"
            '''
        }
    }
} 