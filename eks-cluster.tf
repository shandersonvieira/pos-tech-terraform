resource "aws_eks_cluster" "cluster" {
  name     = "${var.project_name}-infra-eks"
  role_arn = var.labRole
  version  = "1.32"

  tags = {
    Name = "${var.project_name}-infra-eks"
  }

  vpc_config {
    subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

    security_group_ids = [aws_security_group.eks_nodes_sg.id]
  }

  access_config {
    authentication_mode = var.accessConfig
  }
}
