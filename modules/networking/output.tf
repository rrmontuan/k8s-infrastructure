output "external_access_sg" {
  value = aws_security_group.external_access
}

output "default_sg" {
  value = aws_security_group.default
}

output "subnets" {
  value = aws_subnet.public_subnet
}

output "aws_route_table_association" {
  value = aws_route_table_association.public
}
