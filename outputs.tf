# ECR
output "repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "auth_api_repository_url" {
  value = aws_ecr_repository.api_auth_repo.repository_url
}
