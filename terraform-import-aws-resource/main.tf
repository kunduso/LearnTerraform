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
    Name = "web-tier"
  }
}

# Import blocks for public subnets
import {
  to = aws_subnet.web_tier_public_1
  id = "subnet-0ea4fe97c34c804e6"
}

import {
  to = aws_subnet.web_tier_public_2
  id = "subnet-05b20b4d8660a2bd4"
}

# Public subnet resources
resource "aws_subnet" "web_tier_public_1" {
  vpc_id            = aws_vpc.imported_vpc.id
  cidr_block        = "12.25.15.0/27"  # You'll need to verify this CIDR
  availability_zone = "us-west-2a"

  tags = {
    Name = "web-tier-public-1"
  }
}

resource "aws_subnet" "web_tier_public_2" {
  vpc_id            = aws_vpc.imported_vpc.id
  cidr_block        = "12.25.15.32/27"  # You'll need to verify this CIDR
  availability_zone = "us-west-2b"

  tags = {
    Name = "web-tier-public-2"
  }
}