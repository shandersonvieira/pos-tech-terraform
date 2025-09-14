resource "aws_ecr_repository" "app" {
  name                 = "${var.projectName}-repo"
  image_tag_mutability = "MUTABLE"

  tags = var.tags
}
