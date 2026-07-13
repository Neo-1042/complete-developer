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