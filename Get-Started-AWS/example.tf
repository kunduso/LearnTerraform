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
  key_name = "terraform-key"
  security_groups = ["${aws_security_group.allow_rdp.name}"]
}

resource "aws_security_group" "allow_rdp" {
  name = "allow_rdp"
  description = "allow traffic"

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}