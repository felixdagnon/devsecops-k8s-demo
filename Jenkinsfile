pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "felixdagnon/numeric-app:${GIT_COMMIT}"
        MAVEN_OPTS = "-Dmaven.repo.local=.m2/repository"
    }

    tools {
        maven 'Maven3'   // Définir dans Jenkins > Global Tool Configuration
        jdk 'JDK11'      // ou JDK17 selon ton projet
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
                withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
                    echo "=== Building Docker image ==="
                    sh "docker build -t ${DOCKER_IMAGE} ."

                    echo "=== Pushing Docker image ==="
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
    }
    
    post {
        always {
            echo "=== Pipeline finished ==="
        }
        success {
            echo "=== Pipeline succeeded ==="
        }
        failure {
            echo "=== Pipeline failed ==="
        }
    }
}


