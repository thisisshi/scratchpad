resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "key" {
  key_name   = "test-key"
  public_key = tls_private_key.key.public_key_openssh
  tags = {
    Name = "${var.tag_prefix} Bastion Key"
  }
}

output "private_key" {
  value = tls_private_key.key.private_key_pem
}
