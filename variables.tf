variable "region_default" {
  default = "us-east-1"
}

variable "project_name" {
  default = "soat"
}

# IAM
variable "principalArn" {
  # ARN Substituir pelo usuário da conta
  default = "arn:aws:iam::058264083210:role/voclabs"
}
variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

# EKS
variable "labRole" {
  default = "arn:aws:iam::058264083210:role/LabRole"
}
variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}
variable "instance_type" {
  default = "t2.medium"
}
