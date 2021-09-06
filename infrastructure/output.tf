output "devopslink-public-zone-id" {
  value = "Z044998812FDL3JSZ0XD0"
}

output "private_key" {
  value = tls_private_key.server-key.private_key_pem
  sensitive = true
}

output "server_ip" {
  value = aws_instance.server.public_ip
}

output "ecr_repo" {
  value = aws_ecr_repository.minecraft-server.name
}
