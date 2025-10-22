terraform {
  backend "s3" {
    bucket       = "kunduso-terraform-remote-bucket"
    encrypt      = true
    key          = "tf/learn-terraform/terraform-import-aws-resource/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}