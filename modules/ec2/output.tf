output "nodes_public_ips" {
  value = aws_instance.nodes.*.public_ip
}

output "server_public_ip" {
  value = aws_instance.server.public_ip
}
