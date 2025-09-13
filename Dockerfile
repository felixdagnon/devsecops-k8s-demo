# Base image Java 8
FROM openjdk:8-jdk-alpine

# Expose port 8080
EXPOSE 8080

# Argument JAR_FILE par défaut
ARG JAR_FILE=target/*.jar

# Copier le JAR dans l'image
COPY ${JAR_FILE} app.jar

# Commande pour lancer Spring Boot
ENTRYPOINT ["java", "-jar", "/app.jar"]
