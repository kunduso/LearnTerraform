terraform {
    backend "s3" {
        bucket = "skundu-terraform-remote-state"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}