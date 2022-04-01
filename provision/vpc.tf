resource "aws_vpc" "vpc" {
  cidr_block           = "172.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    project = var.project_name
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    project = var.project_name
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    project = var.project_name
  }
}

resource "aws_route_table" "vpc_routes" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ig.id
  }

  tags = {
    project = var.project_name
  }
}

resource "aws_route_table_association" "subnet_routes" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.vpc_routes.id
}

resource "aws_security_group" "sg" {
  name   = "allow_ingress"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["${var.admin_static_ip}/32"]
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = var.project_name
  }
}
