pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub'   // ID des credentials Jenkins
        DOCKER_IMAGE = "siddharth67/numeric-app"
    }

    stages {
        stage('Build Artifact') {
            steps {
                echo "=== Building the project ==="
                sh "mvn clean package -DskipTests=true"

                // Renommer le JAR pour Docker
                sh "cp target/*.jar target/app.jar"

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

        stage('Docker build and push') {
            steps {
                script {
                    echo "=== Logging to DockerHub ==="
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        echo "=== Building Docker image ==="
                        sh "docker build -t ${DOCKER_IMAGE}:${GIT_COMMIT} ."

                        echo "=== Pushing Docker image ==="
                        sh "docker push ${DOCKER_IMAGE}:${GIT_COMMIT}"
                    }
                }
            }
        }
    }
}

