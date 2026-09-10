
terraform {
  backend "s3" {
    bucket       = "terraform-remote-state-076680484948"
    key          = "tf/aws-iam-auto-pilot/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}