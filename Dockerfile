# Utiliser l'image JDK Alpine pour un conteneur léger
FROM openjdk:8-jdk-alpine

# Exposer le port sur lequel Spring Boot écoute
EXPOSE 8080

# Définir l'argument pour le JAR à copier
ARG JAR_FILE=target/numeric-0.0.1.jar

# Copier le JAR dans le conteneur
COPY ${JAR_FILE} app.jar

# Définir le point d'entrée pour lancer l'application
ENTRYPOINT ["java", "-jar", "/app.jar"]
