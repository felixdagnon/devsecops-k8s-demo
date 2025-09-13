# Utilise une image OpenJDK légère
FROM openjdk:8-jdk-alpine

# Expose le port 8080 de l'application
EXPOSE 8080

# Définit le JAR généré par Maven comme argument
ARG JAR_FILE=target/*.jar

# Copie le JAR dans le conteneur
COPY ${JAR_FILE} app.jar

# Point d'entrée de l'application
ENTRYPOINT ["java", "-jar", "/app.jar"]
