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

## Multi Stage Dockerfile 

Previously, we created the *.jar file separately. Now, we can
add this step as part of the creation of the Docker image
(best practice).

1. Stage I  --> Build the jar file. Notice that this stage
is given the name `AS build`.
2. Stage II --> Run the jar file

```docker
FROM maven:3.8.6-openjdk-18-slim AS build
WORKDIR /home/app
COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:18.0-slim
VOLUME /tmp
EXPOSE 8080
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]
```

In this way, your build does not make use of anything built on
your local machine.

With this new Dockerfile, let's build a new docker image:

```bash
docker container stop IMAGE_ID
docker container ls

docker build -t neo_1042/hello-world-docker:v2 .

docker image ls

# RUN
docker container run -d -p 5000:5000 neo_1042/hello-world-docker:v2
```

## Optimizing the Dockerfile: Layer Caching

```docker
FROM maven:3.8.6-openjdk-18-slim AS build
WORKDIR /home/app

COPY ./pom.xml /home/app/pom.xml
COPY ./src/main/java/com/example/demodocker/DemoDockerApplication.java /
/home/app/src/main/java/com/example/demodocker/DemoDockerApplication.java

RUN mvn -f /home/app/pom.xml clean package

COPY . /home/app/pom.xml clean package

FROM openjdk:18.0-slim
EXPOSE 5000
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]
```

Docker uses and tries to reuse layers. If nothing changes
in one layer
from a given `docker build ...` to the next, Docker will try
to reuse said layer.
For Java applications, one of the steps that take the most
time is downloading dependencies (`mvn clean package`).
Luckily, dependencies don't usually change from one image build
to another, so Docker take advantage of this by first 
triggering a build only with the `DemoDockerApplication.java`
and the `pom.xml` files (since these two don't change often)
and separating them from the other commands, like this:

```docker
[...]
COPY ./pom.xml /home/app/pom.xml
COPY ./src/main/java/com/example/demodocker/DemoDockerApplication.java /
/home/app/src/main/java/com/example/demodocker/DemoDockerApplication.java

RUN mvn -f /home/app/pom.xml clean package
[...]
```

Thus, if you don't make any changes to the
`DemoDockerApplication.java` nor the main `pom.xml` files,
the first five commands in the `Dockerfile` will be REUSED.

The first `RUN mvn -f /home/app/pom.xml clean package` command
will download the dependencies, thereby reducing the time
of the following image build processes.

When you reuse cached steps, you will see something similar to
the following output after runing
`docker build -t neo_1042/hello-world-docker:v4`:

```log
 => CACHED [build 2/7] WORKDIR ... 0.0s
 => CACHED [build 3/7] COPY ... 0.0s
 => CACHED [build 4/7] COPY ... 0.0s
 => CACHED [build 5/7] RUN ... 0.0s
 => [build 6/7] COPY ... 0.1s
 => [build 7/7] RUN ... 32.9s
```