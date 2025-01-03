# module "vpc" {
#   source                  = "github.com/kunduso/terraform-aws-vpc?ref=v1.0.2"
#   region                  = var.region
#   enable_internet_gateway = true
#   vpc_cidr                = "11.22.35.0/24"
#   subnet_cidr_public      = ["11.22.35.0/27", "11.22.35.32/27", "11.22.35.64/27"]
#   subnet_cidr_private     = ["11.22.35.128/27", "11.22.35.160/27", "11.22.35.192/27"]
#   #CKV_TF_1: Ensure Terraform module sources use a commit hash
#   #checkov:skip=CKV_TF_1: This is a self hosted module where the version number is tagged rather than the commit hash.
# }