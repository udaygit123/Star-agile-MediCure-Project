FROM openjdk:11
COPY target/*.jar MediCure.jar
CMD ["java", "-jar", "MediCure.jar"]

