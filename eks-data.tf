// LabRole
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

data "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

# data "aws_subnet" "subnet" {
#   for_each = toset(data.aws_subnets.subnets.ids)
#   id       = each.value
# }

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.cluster.name
}

# data "kubernetes_service" "nginx_lb" {
#   metadata {
#     name      = "nginx-service"
#     namespace = "nginx"
#   }
# }
