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
  bucket = "${var.bucket_name}-${random_integer.rand_int.result}"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}