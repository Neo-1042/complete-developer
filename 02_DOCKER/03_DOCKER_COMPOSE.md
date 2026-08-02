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