pipeline {
    agent any

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
                    // Publier le rapport JaCoCo dans Jenkins
                    jacoco execPattern: 'target/jacoco.exec',
                           classPattern: 'target/classes',
                           sourcePattern: 'src/main/java',
                           inclusionPattern: '**/*.class',
                           exclusionPattern: '**/*Test*.class'
                }
            }
        }
    }
}

