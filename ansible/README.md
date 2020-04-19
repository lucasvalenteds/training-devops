# Ansible

It demonstrates how to automate deployment of a Go microservice inside a VM provisioned by Vagrant and configured by Ansible.

## How to run

| Description | Command |
| :--- | :--- |
| Run Ansible playbook inside a VM | `vagrant up --provision` |

### How to test

| Feature | Command |
| :--- | :--- |
| Execute an operation | `curl http://192.168.100.11:8080/calc/sum/2/3` |
| See operations done in the past | `curl http://192.168.100.11:8080/calc/history` |
