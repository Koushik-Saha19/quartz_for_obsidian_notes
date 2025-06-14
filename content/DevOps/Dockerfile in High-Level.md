

Below is an example Dockerfile of a Java Spring-Boot application


FROM eclipse-temurin:8-jdk  ---- Base Image
ADD risk-listener.jar app.jar   ---- Adding the JAR file
EXPOSE 8080 ---- exposing a port through which application will receive request
ENV SPRING_PROFILES_ACTIVE=not-local  ---- setting an environment variable
CMD ["java", "-jar", "/app.jar"]  ---- starting the application