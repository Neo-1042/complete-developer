# Docker Compose

A tool for defining and running multi-container Docker
applications. With **Docker Compose**, you create and start
all the services from your configuration.

1. Define your app's environment with a `Dockerfile` so it
can be reproduced anywhere.

2. Define the services that make up your app in
`docker-compose.yml` so they can be run together in an
isolated environment.

3. Run `docker-compose up` and Compose starts and runs
your entire app.

<u>IMPORTANT NOTE:</u> Do NOT use tabs for the yaml file.
Instead, use **double spaces** to write the indentation.

```bash
docker-compose --version
```

File = docker-compose.yaml
```yml
version: '3.7'

services:
  currency-exchange:
    image: neo_1042/mmv2-currency-exchange-service:0.0.1-SNAPSHOT
    mem_limit: 700m
    ports:
      - "8000:8000"
    networks:
      - currency-network

networks:
  currency-network:
```

> `docker-compose up`

## A More Complete Example

File = docker-compose.yaml
```yml
version: '3.7'

services:
  currency-exchange:
    image: neo_1042/mmv2-currency-exchange-service:0.0.1-SNAPSHOT
    mem_limit: 700m
    ports:
      - "8000:8000"
    networks:
      - currency-network
    depends_on:
      - naming-server
    environment:
      EUREKA.CLIENT.SERVICEURL.DEFAULTZONE: http://naming-server:8761/eureka
      SPRING.ZIPKIN.BASEURL: http://zipkin-server:9411/

  naming-server:
    image: neo_1042/mmv2-naming-server:0.0.1-SNAPSHOT
    mem_limit: 700m
    ports:
      - "8761:8761"
    networks:
      - currency-network

  api-gateway:
    image: neo_1042/mmv2-api-gateway:0.0.1-SNAPSHOT
    mem_limit: 700m
    ports:
      - "8765:8765"
    networks:
      currency-network
    depends_on:
      - naming-server
    environment:
      EUREKA.CLIENT.SERVICEURL.DEFAULTZONE: http://naming-server:8761/eureka
      SPRING.ZIPKIN.BASEURL: http://zipkin-server:9411/

  zipkin-server:
    image: openzipkin/zipkin:2.23
    mem_limit: 300m
    ports:
      - "9411:9411"
    networks:
      - currency-network
    restart: always

  currency-conversion:
    image: neo_1042/mmv2-currency-conversion-service:0.0.1-SNAPSHOT
    mem_limit: 700m
    ports:
      - "8100:8100"
    networks:
      - currency-network
    depends_on:
      - naming-server
    environment:
      EUREKA.CLIENT.SERVICEURL.DEFAULTZONE: http://naming-server:8761/eureka
      SPRING.ZIPKIN.BASEURL: http://zipkin-server:9411/

networks:
  currency-network:
```

`docker-compose up`