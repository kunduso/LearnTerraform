terraform {
  cloud {
    organization = "kunduso"
    workspaces {
      name = "app-two-layer-0"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.2"
    }
  }
  required_version = "~> 1.2"
}
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Source = "https://github.com/kunduso/app-two"
    }
  }
}