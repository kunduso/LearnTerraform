terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = "t2.micro"

  provisioner "local-exec" {
  command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}