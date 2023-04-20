FROM openjdk:11
COPY target/*.jar MediCure-0.0.1-SNAPSHOT.jar
CMD ["java", "-jar", "/MediCure-0.0.1-SNAPSHOT.jar"]
