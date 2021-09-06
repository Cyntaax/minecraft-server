resource "aws_ecr_repository" "minecraft-server" {
  name = "minecraft-server"
  image_tag_mutability = "MUTABLE"
}
