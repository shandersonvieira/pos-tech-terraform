variable "region_default" {
  default = "us-east-1"
}

variable "projectName" {
  default = "soat-fiap-fast-food-tech-challenge"
}

variable "bucket_name" {
  default = "fiap-soat-tc-terraform"
}

# Tags
variable "tags" {
  default = {
    Project = "Fast Food Tech Challenge"
    Owner   = "SOAT"
  }
}

# Networking
variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

# IAM
variable "principalArn" {
  # ARN Substituir pelo usuário da conta
  default = "arn:aws:iam::273703201222:role/voclabs"
}
variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

# EKS
variable "labRole" {
  default = "arn:aws:iam::273703201222:role/LabRole"
}
variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}
variable "instance_type" {
  default = "t2.micro"
}
