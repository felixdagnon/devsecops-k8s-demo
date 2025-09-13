pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-hub'   // Nom exact de ton credential Jenkins
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
                withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: ""]) {
                    sh "docker build -t siddharth67/numeric-app:${GIT_COMMIT} ."
                    sh "docker push siddharth67/numeric-app:${GIT_COMMIT}"
                }
            }
        }
    }
}
