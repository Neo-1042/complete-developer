# Dockerfile

Goal = **Dockerizing** a Java application made with
Spring Boot.

This file must be located next to the main `pom.xml` file.

File = Dockerfile

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

# Dockerizing a Java Spring Boot App

1. Add the Dockerfile to the root of the project. 
2. Make sure the app (service) runs properly
(`mvn clean install; java -jar target/*.jar`)
3. Validate that docker is installed with:  
    `docker --version`
4. Check that the container is not yet running with: 
    `docker container ls`
5. Build the Docker image (don't forget the context, which in this case is the current folder (`.`)):

`docker build -t neo_1042/hello-world-docker:v1 .`

6. Check that the docker image was successfully created:  
    `docker image ls`
7. Run the newly created docker image:  
    `docker run -d -p 5000:5000 neo_1042/hello-world-docker:v1`
8. Validate that the image is running (i.e. it becomes a
**Docker container**):  
    `docker container ls`