# Dockerfile

Goal = **Dockerizing** a Java application made with
Spring Boot.

This file must be located at:
File = Dockerfile.txt

```docker
FROM openjdk:18.0-slim
COPY target/*.jar app.jar
EXPOSE 5000
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

- `FROM` --> Sets a base image.
- `COPY` --> Copies new files or directories into the image.
- `EXPOSE` --> Informs docker about the port that the container
listens on at runtime.
- `ENTRYPOINT` --> Configure a command that will be run at
container launch.