resource "aws_route53_zone" "local" {
  name = var.domain_name

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_route53_record" "node1" {
  zone_id = aws_route53_zone.local.zone_id
  name    = "node1.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [
    aws_instance.ec2_1.private_ip
  ]
}

resource "aws_route53_record" "node2" {
  zone_id = aws_route53_zone.local.zone_id
  name    = "node2.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [
    aws_instance.ec2_2.private_ip
  ]
}


resource "aws_route53_record" "node3" {
  zone_id = aws_route53_zone.local.zone_id
  name    = "node3.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [
    aws_instance.ec2_3.private_ip
  ]
}

