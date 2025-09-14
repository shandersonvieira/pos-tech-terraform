resource "aws_security_group" "sg" {
  name        = "${var.projectName}-sg"
  description = "Usado para expor services na internet"
  vpc_id      = aws_vpc.vpc_fiap.id
  # tags        = var.tags

  #Trafego de Entrada para o Cluster (e serviços) vindos da AWS
  ingress {
    description = "HTTP"
    #Libera apenas a porta 80
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Abre para a internet
  }

  #Trafego de Saida do Cluster (e serviços) para a internet
  egress {
    description = "All"
    #Libera todas as portas
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          #Todos os protocolos
    cidr_blocks = ["0.0.0.0/0"] #Abre para a internet
  }


}
