# Packer

It demonstrates how to build a Docker image using Packer instead of a Dockerfile.

## How to run

| Description | Command |
| :--- | :--- |
| Build Docker image using Packer | `packer build template.json` |
| Run image built | `docker run --rm --detach -p 8080:8080 --name calculator-microservice calculator-microservice` |
| Stop container | `docker stop calculator-microservice` |

## How to test

| Feature | Command |
| :--- | :--- |
| Execute an operation | `curl http://localhost:8080/calc/sum/2/3` |
| See operations done in the past | `curl http://localhost:8080/calc/history` |
