resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = "terraform-key"
  security_groups = ["${aws_security_group.allow_rdp.name}"]
  count = var.instance_count
  tags = {
    Name = "Web-App-Prod-1"
  }
}