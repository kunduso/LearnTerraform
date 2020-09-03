terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0239d3998515e9ed1"
  instance_type = "t2.micro"

  provisioner "local-exec" {
  command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}