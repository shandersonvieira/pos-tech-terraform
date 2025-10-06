# Security Group principal para os nós do EKS.
# Este SG controla o que pode entrar e sair dos seus worker nodes.
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.project_name}-eks-nodes-sg"
  description = "Security Group for the EKS worker nodes"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  tags = {
    Name = "${var.project_name}-eks-nodes-sg"
  }

  # Regra de Entrada (Ingress):
  # Permite que os nós se comuniquem entre si dentro do cluster. Essencial para a rede do K8s.
  ingress {
    description = "Node-to-node communication within the cluster"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos os protocolos
    self        = true # Permite tráfego originado do próprio SG
  }

  # Permite tráfego vindo de QUALQUER LUGAR DENTRO da VPC.
  # Isso permite que o Load Balancer (que está na VPC) se conecte aos nós.
  ingress {
    description = "Allow traffic from within the VPC (e.g., from Load Balancer)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Usa o bloco CIDR da sua VPC como fonte, lido do estado remoto da rede.
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr_block]
  }

  # Regra de Saída (Egress):
  # Permite que os nós acessem a internet através do NAT Gateway para baixar imagens, etc.
  egress {
    description = "Allow all outbound traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Regra de Segurança ADICIONAL E SEPARADA.
# Esta regra é adicionada ao Security Group do RDS, permitindo que os nós do EKS
# se conectem ao banco de dados na porta do PostgreSQL.
resource "aws_security_group_rule" "eks_to_rds" {
  type        = "ingress"
  description = "Allow EKS nodes to connect to RDS"
  from_port   = 5432 # Porta do PostgreSQL
  to_port     = 5432
  protocol    = "tcp"

  # Alvo: O Security Group do RDS (lido do estado remoto do DB)
  security_group_id = data.terraform_remote_state.database.outputs.rds_sg_id

  # Fonte: O Security Group dos nós do EKS (criado acima)
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}