resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.labRole
  subnet_ids      = data.terraform_remote_state.network.outputs.private_subnet_ids
  disk_size       = 50
  instance_types  = [var.instance_type]
  tags = {
    Name = "${var.project_name}-eks-node-group"
  }


  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
