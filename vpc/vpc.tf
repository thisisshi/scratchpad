data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Sandbox Sonny VPC"
  }
}

resource "aws_subnet" "zones" {
  for_each = zipmap(
    [for az in local.azs : join("", [data.aws_region.current.name, az])],
    cidrsubnets("10.0.0.0/16", 3, 3, 3, 3, 3, 3)
  )
  availability_zone       = each.key
  cidr_block              = each.value
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tag_prefix} VPC Subnet ${each.key}"
    AZ   = each.key
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_prefix} IGW"
  }
}

resource "aws_security_group" "sg" {
  name        = "Permissive"
  description = "A very permissive security group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Full Permissions"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Full Permissions"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_prefix} Permissive SG"
  }
}

resource "aws_route_table_association" "rtb_assoc" {
  for_each       = aws_subnet.zones
  subnet_id      = each.value.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
