resource "aws_eks_cluster" "cluster" {
  name     = "eks-${var.projectName}"
  role_arn = var.labRole
  version  = "1.32"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_public[0].id,
      aws_subnet.subnet_public[1].id,
      aws_subnet.subnet_public[2].id
    ]
    security_group_ids = [aws_security_group.sg.id]
  }

  access_config {
    authentication_mode = var.accessConfig
  }
}
