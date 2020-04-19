terraform {
  required_version = ">= 0.12"
}



variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_region" {
  description = "AWS region to deploy"
  default     = "sa-east-1"
}

variable "aws_instance_type" {
  description = "Machine type"
  default     = "t2.micro"
}

variable "aws_key_name" {
  description = "Item on 'Key Pairs' menu"
  default     = "kp-tema13-devops"
}

variable "app_name" {
  description = "How to call the application deployed"
  default     = "calculator-microservice"
}



provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}



resource "aws_security_group" "default" {
  name = "sg_default"
  description = "It allows to access instances via browser and SSH"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_elb" "default" {
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 8080
    instance_protocol = "http"
  }

  instances = ["${aws_instance.web.id}"]
  availability_zones = ["${aws_instance.web.availability_zone}"]

  tags = {
    Name = "elb_calculator"
  }
}



resource "aws_instance" "web" {
  ami = "${data.aws_ami.ami_calculator.id}"
  instance_type = "${var.aws_instance_type}"
  key_name = "${var.aws_key_name}"

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = file("${path.module}/${var.aws_key_name}.pem")
  }

  security_groups = ["${aws_security_group.default.name}"]

  provisioner "remote-exec" {
    inline = [
      "sudo service calculator start",
    ]
  }
}



data "aws_ami" "ami_calculator" {
  filter {
    name = "name"
    values = ["calculator"]
  }

  filter {
    name = "state"
    values = ["available"]
  }

  owners = ["self"]
  most_recent = true
}



resource "aws_launch_configuration" "lc_default" {
  image_id = "${data.aws_ami.ami_calculator.id}"
  instance_type = "${var.aws_instance_type}"
}

resource "aws_autoscaling_group" "asg_default" {
  launch_configuration = "${aws_launch_configuration.lc_default.id}"
  availability_zones = ["${var.aws_region}a"]
  load_balancers = ["${aws_elb.default.id}"]

  max_size = 2
  min_size = 1
  force_delete = true
  health_check_type = "ELB"

  lifecycle {
    create_before_destroy = true
  }
}



output "elb_address" {
  value = "${aws_elb.default.dns_name}"
}
