#Tabela de rotas
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_fiap.id
  tags   = var.tags

  #Rota para utilização Local
  route {
    cidr_block = aws_vpc.vpc_fiap.cidr_block
    gateway_id = "local"
  }

  #Rota para utilização na Internet
  route {
    cidr_block = "0.0.0.0/0" #Aberto para todas as origens
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Associa a tabela de rotas com IPs públicos as subnets
resource "aws_route_table_association" "rt_association_0" {
  subnet_id      = aws_subnet.subnet_public[0].id
  route_table_id = aws_route_table.rt_public.id
}

#Associa a tabela de rotas com IPs públicos as subnets
resource "aws_route_table_association" "rt_association_1" {
  subnet_id      = aws_subnet.subnet_public[1].id
  route_table_id = aws_route_table.rt_public.id
}

#Associa a tabela de rotas com IPs públicos as subnets
resource "aws_route_table_association" "rt_association_2" {
  subnet_id      = aws_subnet.subnet_public[2].id
  route_table_id = aws_route_table.rt_public.id
}
