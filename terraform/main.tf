variable "image_name" {
  type = string
  description = "The machine image to be provisioned"
}

resource "aws_instance" "calculator-microservice" {
  instance_type = "t2.micro"
  ami = var.image_name
}
