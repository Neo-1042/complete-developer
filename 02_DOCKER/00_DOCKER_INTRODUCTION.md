### Advantages of Microservices Architecture

Build small, focused microservices such as:  
{MovieService, CustomerService, ReviewService, BookingService,
FareCalculationService}, each with its own database and in its
own programming language (Go, Java, Python, JavaScript).

However, **deployments can become very complex**.
How can you get one common way to deploy multiple
microservices, irrespective of the programming language used?

# Docker

Docker is a container that allows you to create an image
for each microservice, using the following infrastructure:

```
----------------------------------------------
| Container 1 |  Container 2  | Container 3  |
----------------------------------------------
|               Docker Engine                |
----------------------------------------------
|               Linux (RHEL)                 |
----------------------------------------------
|               Cloud Infrastructure         |
----------------------------------------------
```

Every Docker image contains everything a microservice needs
to run:
- Application Runtime (JDK, Python, NodeJS, etc.)
- Application Code
- Dependencies

## Recommendations

1. Use PowerShell instead of CMD.
2. If you are using Windows 10 and **docker toolbox**, use
`192.168.99.100` instead of localhost
(Or run `docker-machone ip` to find out the IP address).

3. This course requires **Docker Desktop** (docker.com)  
Alternatively, use **Podman Desktop** (podman-desktop.io)

Tip for macOS:
```bash
# Install Rosetta 2
softwareupdate --install-rosetta --agree-to-license
```

## Useful Docker Commands

```bash
docker container run -d -p 5000:5000 in28min/hello-world-nodejs:0.0.1.RELEASE
docker container run -d -p 5000:5000 in28min/hello-world-java:0.0.1.RELEASE
docker container run -d -p 5000:5000 in28min/hello-world-python:0.0.1.RELEASE
docker container ls 
docker image ls
docker container stop cc
docker container run -d -p 5001:5000 in28min/hello-world-nodejs:0.0.1.RELEASE
docker container run -d -p 5002:5000 in28min/hello-world-nodejs:0.0.1.RELEASE
docker container run -p 5003:5000 in28min/hello-world-nodejs:0.0.1.RELEASE
docker container run -p 5003:5000 in28min/hello-world-nodejs:0.0.1.RELEASE
 
docker --version
docker container ls
docker build -t in28min/hello-world-docker:v1 .
docker image list
docker run -d -p 5000:5000 in28min/hello-world-docker:v1
docker build -t in28min/hello-world-docker:v2 .
docker container run -d -p 5000:5000 in28min/hello-world-docker:v2
docker build -t in28min/hello-world-docker:v3 .
docker container run -d -p 5000:5000 in28min/hello-world-docker:v3
docker build -t in28min/hello-world-docker:v4 .
```
