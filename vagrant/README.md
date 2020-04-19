# Vagrant

It demonstrates how to provision a virtual machine using Vagrant to host a microservice written in Go that executes basic math operations via HTTP calls.

## How to run

| Description | Command |
| :--- | :--- |
| Run app | `go run main.go` |

### How to deploy

| Description | Command |
| :--- | :--- |
| Build the app | `go build -o app` |
| Create the VM | `vagrant up` |
| Stop the VM | `vagrant halt` |
| Delete the VM | `vagrant destroy` |

### How to test

| Feature | Command |
| :--- | :--- |
| Execute an operation | `curl http://192.168.100.10:8080/calc/sum/2/3` |
| See operations done in the past | `curl http://192.168.100.10:8080/calc/history` |
