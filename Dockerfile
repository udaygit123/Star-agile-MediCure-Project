FROM openjdk:11
COPY target/*.jar medicure-0.0.1-SNAPSHOT.jar 
CMD ["java","-jar"," /medicure-0.0.1-SNAPSHOT.jar"]
