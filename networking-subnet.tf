resource "aws_subnet" "subnet_public" {
  count  = 3
  vpc_id = aws_vpc.vpc_fiap.id

  cidr_block = cidrsubnet(aws_vpc.vpc_fiap.cidr_block, 4, count.index)

  map_public_ip_on_launch = true

  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]

  tags = var.tags
}

resource "aws_subnet" "subnet_private" {
  count  = 3
  vpc_id = aws_vpc.vpc_fiap.id

  cidr_block = cidrsubnet(aws_vpc.vpc_fiap.cidr_block, 4, count.index + 3)

  map_public_ip_on_launch = false

  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"][count.index]

  tags = merge(var.tags, { "Tier" = "Private" })
}
