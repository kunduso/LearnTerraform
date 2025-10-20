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
  cidr_block        = "12.25.15.0/27" # You'll need to verify this CIDR
  availability_zone = "us-west-2a"

  tags = {
    Name = "web-tier-public-1"
  }
}

resource "aws_subnet" "web_tier_public_2" {
  vpc_id            = aws_vpc.imported_vpc.id
  cidr_block        = "12.25.15.32/27" # You'll need to verify this CIDR
  availability_zone = "us-west-2b"

  tags = {
    Name = "web-tier-public-2"
  }
}
# Import blocks for private subnets
import {
  to = aws_subnet.web_tier_private_1
  id = "subnet-06b929c181ad6c4ff"
}

import {
  to = aws_subnet.web_tier_private_2
  id = "subnet-07838fbfa5c1efc17"
}

# Private subnet resources
resource "aws_subnet" "web_tier_private_1" {
  vpc_id            = aws_vpc.imported_vpc.id
  cidr_block        = "12.25.15.64/27" # You'll need to verify this CIDR
  availability_zone = "us-west-2a"

  tags = {
    Name = "web-tier-private-1"
  }
}

resource "aws_subnet" "web_tier_private_2" {
  vpc_id            = aws_vpc.imported_vpc.id
  cidr_block        = "12.25.15.96/27" # You'll need to verify this CIDR
  availability_zone = "us-west-2b"

  tags = {
    Name = "web-tier-private-2"
  }
}
# Import blocks for route tables
import {
  to = aws_route_table.web_tier_public
  id = "rtb-0051b74c62960239a"
}

import {
  to = aws_route_table.web_tier_private_1
  id = "rtb-096262c0795386cb0"
}

import {
  to = aws_route_table.web_tier_private_2
  id = "rtb-066e3d20ee79c434a"
}

# Route table resources
resource "aws_route_table" "web_tier_public" {
  vpc_id = aws_vpc.imported_vpc.id

  tags = {
    Name = "web-tier-public"
  }
}

resource "aws_route_table" "web_tier_private_1" {
  vpc_id = aws_vpc.imported_vpc.id

  tags = {
    Name = "web-tier-private-1"
  }
}

resource "aws_route_table" "web_tier_private_2" {
  vpc_id = aws_vpc.imported_vpc.id

  tags = {
    Name = "web-tier-private-2"
  }
}

# Route table associations
resource "aws_route_table_association" "web_tier_public_1" {
  subnet_id      = aws_subnet.web_tier_public_1.id
  route_table_id = aws_route_table.web_tier_public.id
}

resource "aws_route_table_association" "web_tier_public_2" {
  subnet_id      = aws_subnet.web_tier_public_2.id
  route_table_id = aws_route_table.web_tier_public.id
}

resource "aws_route_table_association" "web_tier_private_1" {
  subnet_id      = aws_subnet.web_tier_private_1.id
  route_table_id = aws_route_table.web_tier_private_1.id
}

resource "aws_route_table_association" "web_tier_private_2" {
  subnet_id      = aws_subnet.web_tier_private_2.id
  route_table_id = aws_route_table.web_tier_private_2.id
}