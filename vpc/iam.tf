resource "aws_iam_instance_profile" "installer" {
  name = "installer_profile"
  role = aws_iam_role.installer.name
}

resource "aws_iam_role" "installer" {
  name = "stacklet-installer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "${var.tag_prefix} Stacklet Installer"
  }
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.installer.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
