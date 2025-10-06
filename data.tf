# Este bloco lê o estado remoto do seu projeto de rede base.
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "soat-tfstate-bucket"
    key    = "infra/terraform.tfstate"
    region = var.region_default
  }
}

# Mantemos os data sources para o EKS funcionar com o provider Kubernetes
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.cluster.name
}

data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = "soat-tfstate-bucket"
    key    = "database/terraform.tfstate"
    region = var.region_default
  }
}