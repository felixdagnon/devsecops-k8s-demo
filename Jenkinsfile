pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-hub'  // ID du credential Jenkins pour Docker Hub
        DOCKER_IMAGE = "felixdagnon/numeric-app"
    }

    stages {

        stage('Build Artifact') {
            steps {
                echo "=== Building Maven project ==="
                sh "mvn clean package -DskipTests=true"
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Unit Tests & Coverage') {
            steps {
                echo "=== Running tests with JaCoCo coverage ==="
                sh "mvn test jacoco:report"
            }
            post {
                always {
                    jacoco execPattern: 'target/jacoco.exec',
                           classPattern: 'target/classes',
                           sourcePattern: 'src/main/java',
                           inclusionPattern: '**/*.class',
                           exclusionPattern: '**/*Test*.class'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    echo "=== Building Docker image ==="
                    sh "docker build -t ${DOCKER_IMAGE}:${GIT_COMMIT} ."
                    
                    echo "=== Pushing Docker image ==="
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: "https://index.docker.io/v1/"]) {
                        sh "docker push ${DOCKER_IMAGE}:${GIT_COMMIT}"
                        sh "docker tag ${DOCKER_IMAGE}:${GIT_COMMIT} ${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    }

    post {
        success { echo "✅ Pipeline finished successfully!" }
        failure { echo "❌ Pipeline failed!" }
    }
}
