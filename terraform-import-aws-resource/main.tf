# Import block for existing VPC
import {
  to = aws_vpc.imported_vpc
  id = "vpc-070e2d49d3100f46d"
}

# VPC resource configuration to match the manually created VPC
resource "aws_vpc" "imported_vpc" {
  cidr_block           = "12.25.15.0/25"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "import-vpc"
  }
}