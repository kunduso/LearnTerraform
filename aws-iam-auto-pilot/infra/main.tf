resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "aws-iam-auto-pilot-vpc"
  }
  #checkov:skip=CKV2_AWS_11:Flow logs are not required for this demo VPC implementation
}

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id
}
