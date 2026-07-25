# Spring Boot Maven Plugin + Create Docker Image

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

Using this plugin, you can do the following:

[+] Create executable jar package  
[+] Run Spring Boot application  
[+] Create a Docker Image

Using these commands:
```bash
# Generate jar, war or ear
mvn spring-boot:repackage

# Run the application (build jar + java -jar)
mvn spring-boot:run

# Non-blocking. Use it to run integration tests.
mvn spring-boot:start

# Stop the app started with the start command
mvn spring-boot:stop

# Build a Docker image
mvn spring-boot:build-image
```

Using this plugin, there will be no need to use a
`Dockerfile` (:O).

**OCI** = Open Container Initiative. Docker is compatible with
OCI.

This process creates more efficient (smaller and faster)
images. **Java 17** or later is recommended.

```bash
docker image ls

docker container stop <container_id>

docker container run -d -p 5000:5000 hello-world-java:0.0.1-SNAPSHOT
```