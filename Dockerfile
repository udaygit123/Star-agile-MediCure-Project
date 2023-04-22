FROM openjdk:11
COPY target/*.jar medicure-0.0.1-SNAPSHOT.jar 
ENTRYPOINT ["java","-jar","medicure-0.0.1-SNAPSHOT.jar"]
