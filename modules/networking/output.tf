output "external_access_sg" {
  value = aws_security_group.external_access
}

output "default_sg" {
  value = aws_security_group.default
}
