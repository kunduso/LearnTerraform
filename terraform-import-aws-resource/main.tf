# Import block for existing VPC
import {
  to = aws_vpc.imported_vpc
  id = "vpc-09b1634a885c02134"
}

# VPC resource configuration to match the manually created VPC
resource "aws_vpc" "imported_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "import-vpc"
  }
}