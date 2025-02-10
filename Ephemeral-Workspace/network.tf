module "vpc" {
  source                  = "kunduso/vpc/aws"
  version                 = "1.0.3"
  region                  = var.region
  enable_internet_gateway = true
  vpc_cidr                = "11.22.35.0/24"
  subnet_cidr_public      = ["11.22.35.0/27", "11.22.35.32/27", "11.22.35.64/27"]
  subnet_cidr_private     = ["11.22.35.128/27", "11.22.35.160/27", "11.22.35.192/27"]
}