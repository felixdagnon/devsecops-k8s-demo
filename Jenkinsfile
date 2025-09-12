pipeline {
    agent any

    tools {
        maven 'Maven3'   // définis "Maven3" dans Jenkins > Global Tool Configuration
        jdk 'JDK11'      // idem pour le JDK (ou JDK17 selon ton projet)
    }

    stages {
        stage('Build Artifact') {
            steps {
                sh "mvn clean package -DskipTests=true"
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Unit Tests with JaCoCo') {
            steps {
                sh "mvn test"
            }
        }

        stage('JaCoCo Report') {
            steps {
                jacoco(
                    execPattern: '**/target/jacoco.exec',
                    classPattern: '**/target/classes',
                    sourcePattern: '**/src/main/java',
                    inclusionPattern: '**/*.class',
                    exclusionPattern: '**/*Test*.class'
                )
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'  // Publie les résultats JUnit
        }
    }
}
