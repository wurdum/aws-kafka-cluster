data "aws_ami" "ami" {
  most_recent = true
  owners      = [var.ec2_ami.owner]

  filter {
    name   = "name"
    values = [var.ec2_ami.name]
  }
}

data "aws_eip" "ec2_b_ip" {
  id = var.ec2_bastion_eip_id
}

resource "aws_eip_association" "ec2_b_eip_association" {
  instance_id   = aws_instance.ec2_b.id
  allocation_id = data.aws_eip.ec2_b_ip.id
}

resource "aws_instance" "ec2_b" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"
  key_name      = var.ec2_ssh_key_name

  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  tags = {
    project = var.project_name
    role    = "bastion"
  }
}

resource "aws_instance" "ec2_1" {
  ami           = data.aws_ami.ami.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    project = var.project_name
    role    = "node:zookeeper:kafka_broker:control_center"
    url     = "node1.${var.domain_name}"
  }
}

resource "aws_instance" "ec2_2" {
  ami           = data.aws_ami.ami.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    project = var.project_name
    role    = "node:zookeeper:kafka_broker:schema_registry"
    url     = "node2.${var.domain_name}"
  }
}

resource "aws_instance" "ec2_3" {
  ami           = data.aws_ami.ami.id
  instance_type = var.ec2_instance_type
  key_name      = var.ec2_ssh_key_name

  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    project = var.project_name
    role    = "node:zookeeper:kafka_broker"
    url     = "node3.${var.domain_name}"
  }
}
