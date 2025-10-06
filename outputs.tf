# ECR
output "repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "load_balancer_hostname" {
  description = "O hostname (DNS) do Load Balancer do Ingress Controller do EKS."
  # O valor abaixo é um exemplo comum. Ajuste para a sua configuração.
  # Geralmente vem de um recurso kubernetes_service ou de um módulo do Helm.
  value = module.eks_ingress.hostname
}