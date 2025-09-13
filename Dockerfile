# Utilise une image légère OpenJDK 8
FROM openjdk:8-jdk-alpine

# Expose le port sur lequel l'application Spring Boot tourne
EXPOSE 8080

# Définit le nom du JAR généré par Maven
ARG JAR_FILE=target/numeric-0.0.1.jar

# Copie le JAR dans l'image
COPY ${JAR_FILE} app.jar

# Commande pour lancer l'application
ENTRYPOINT ["java","-jar","/app.jar"]
