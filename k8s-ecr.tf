resource "aws_ecr_repository" "app" {
  name                 = "${var.projectName}-repo"
  image_tag_mutability = "MUTABLE"

  tags = var.tags
}


resource "aws_ecr_repository" "api_auth_repo" {
  name = "api_auth_repo"
}
