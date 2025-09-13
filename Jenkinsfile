pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub' // l’ID de tes credentials Jenkins pour Docker Hub
        IMAGE_NAME = 'siddharth67/numeric-app'
    }

    stages {
        stage('Build Artifact') {
            steps {
                echo "=== Building the project ==="
                sh "mvn clean package -DskipTests=true"
                archiveArtifacts artifacts: 'target/*.jar', followSymlinks: false
            }
        }

        stage('Unit Tests & Code Coverage') {
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

        stage('Docker Build and Push') {
            steps {
                script {
                    echo "=== Building Docker image ==="
                    docker.build("${IMAGE_NAME}:${GIT_COMMIT}", "-f Dockerfile .")

                    echo "=== Pushing Docker image ==="
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${IMAGE_NAME}:${GIT_COMMIT}").push()
                    }
                }
            }
        }
    }
}

