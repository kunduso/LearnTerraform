resource "aws_security_group" "allow_rdp" {
  name = "allow_rdp"
  description = "allow traffic"

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}