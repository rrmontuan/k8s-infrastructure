data "aws_route53_zone" "selected" {
  name    = var.domain
}

resource "aws_route53_record" "nodes" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "*.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = var.nodes_public_ips
}

resource "aws_route53_record" "rancher" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "rancher.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [var.server_public_ip]
}