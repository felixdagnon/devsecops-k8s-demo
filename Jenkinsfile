pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub' // Id de tes credentials Jenkins
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

        stage('Unit Tests') {
            steps {
                echo "=== Running unit tests ==="
                sh "mvn test"
            }
        }

        stage('Code Coverage') {
            steps {
                echo "=== Running JaCoCo coverage ==="
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
                    withDockerRegistry([credentialsId: env.DOCKERHUB_CREDENTIALS, url: '']) {
                        echo "=== Building Docker image ==="
                        sh "docker build -t ${IMAGE_NAME}:${GIT_COMMIT} ."

                        echo "=== Pushing Docker image ==="
                        sh "docker push ${IMAGE_NAME}:${GIT_COMMIT}"
                    }
                }
            }
        }
    }
}




