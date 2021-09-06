
resource "aws_route53_record" "server1-record" {
  zone_id = "Z044998812FDL3JSZ0XD0"
  name    = "${var.sub_domain}.${var.base_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.server.public_ip]
}

