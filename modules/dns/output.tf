output "rancher_dns" {
  value = aws_route53_record.rancher.name
}

output "nodes_dns" {
  value = aws_route53_record.nodes.name
}
