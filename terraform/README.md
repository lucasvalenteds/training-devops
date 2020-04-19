# Terraform

It's a tool to provision machines on cloud providers like AWS, GCP e Azure. Given a `.tf` file with the infrastructure settings, Terraform will manage their lifecycle (creating, updating, destroying).

It also may be used together with Ansible, since both tools are meant to be used to work with infrastructure provisioning. Their difference is that Terraform does a better job provisioning the machines themselves and Ansible is a great tool to configure the operational system of those machines.

## How to run

| Description | Command |
| :--- | :--- |
| Show the plan to provision | `terraform plan` |
| Execute plan to provision infrastructure | `terraform apply` |
| Show details about the machines provisioned | `terraform show` |
| Show the plan to destroy | `terraform plan --destroy` |
| Execute plan to destroy the infrastructure | `terraform destroy` |
| Download plan from Git repository | `terraform get` |

