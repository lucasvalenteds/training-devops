# Amazon Web Services (AWS)

It demonstrates how to provision a Go microservice on AWS. The provision is made by Terraform and the Amazon Machine Image (AMI) is build by Packer.

## How to run

Access keys should be generated on [Security Credentials](https://console.aws.amazon.com/iam/home?region=sa-east-1#security_credential) page before proceed. They should be set on `aws` script and `packer.json`. A Key Pair should also be generated with name `kp-tema13-devops.pem` and put on this folder.

| Description | Command |
| :--- | :--- |
| Compile the code | `go build -o calculator main.go` |
| Build the AMI | `./aws bake` |
| Provision infrastructure | `./aws deploy` |
| Destroy infrastructure | `./aws clean` |

## How to test

Put the load balancer URL printed after run the deploy task in the script `test.sh` and run it using the command `./test.sh`.

It will make requests to an endpoint and show the result.
