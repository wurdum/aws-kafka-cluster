output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "domain_name" {
  value = var.domain_name
}

output "zone_id" {
  value = aws_route53_zone.local.zone_id
}

output "bastion_public_dns_name" {
  value = aws_instance.ec2_b.public_dns
}

output "node1_public_dns_name" {
  value = aws_instance.ec2_1.public_dns
}

output "node2_public_dns_name" {
  value = aws_instance.ec2_2.public_dns
}

output "node3_public_dns_name" {
  value = aws_instance.ec2_3.public_dns
}
