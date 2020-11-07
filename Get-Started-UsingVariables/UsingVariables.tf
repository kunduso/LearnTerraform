terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.13.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_integer" "rand_int" {
  min = 10000
  max = 99999  
}

resource "aws_s3_bucket" "aws-b1" {
  bucket = "${var.bucket_name[count.index]}-${random_integer.rand_int.result}"
  acl    = "private"
  count  = 3
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_instance" "server" {
  ami = "${var.ami_location["${var.region}"]}"
  instance_type = "t2.micro"
  key_name = "terraform-key"
  security_groups = ["${aws_security_group.allow_rdp.name}"]
  tags = {
    Name = "Web-App-Prod-1"
  }
}