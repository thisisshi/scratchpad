data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  count         = var.bastion
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.key.key_name
  network_interface {
    network_interface_id = aws_network_interface.eni[0].id
    device_index         = 0
  }
  iam_instance_profile = aws_iam_instance_profile.installer.name
  tags = {
    Name = "Sandbox Sonny Bastion"
  }
}

resource "aws_network_interface" "eni" {
  count           = var.bastion
  subnet_id       = aws_subnet.zones["us-east-1a"].id
  private_ips     = ["10.0.0.100"]
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "Sandbox Sonny Bastion ENI"
  }
}

output "ssh_command" {
  value = "ssh -i key.pem ubuntu@${aws_instance.bastion[0].public_ip}"
}
