resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/26"
  tags = {
    Name = "aws-iam-auto-pilot-vpc"
  }
}