pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-hub'  // ID des credentials DockerHub configurés dans Jenkins
        IMAGE_NAME = "siddharth67/numeric-app"
    }

    stages {
        stage('Build Artifact') {
            steps {
                echo "=== Building the project ==="
                sh "mvn clean package -DskipTests=true"
                archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
            }
        }

        stage('Unit Tests') {
            steps {
                echo "=== Running unit tests ==="
                sh "mvn test"
            }
        }

        stage('Code Coverage') {
            steps {
                echo "=== Running tests with JaCoCo coverage ==="
                sh "mvn clean test jacoco:report"
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

        stage('Docker Build and Push') {
            steps {
                echo "=== Building and pushing Docker image ==="
                script {
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: "https://index.docker.io/v1/"]) {
                        sh "docker build -t ${IMAGE_NAME}:${GIT_COMMIT} ."
                        sh "docker push ${IMAGE_NAME}:${GIT_COMMIT}"
                    }
                }
            }
        }
    }
}



