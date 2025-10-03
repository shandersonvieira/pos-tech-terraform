
# # Route Table Public não preciso disso
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = var.tags
# }


# resource "aws_route_table_association" "public_assoc1" {
#   subnet_id      = aws_subnet.public_1.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "public_assoc2" {
#   subnet_id      = aws_subnet.public_2.id
#   route_table_id = aws_route_table.public_rt.id
# }


# NAT Gateway (para que ECS em private tenha saída para internet)
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_public[0].id
  tags          = { Name = "ecs-nat" }
}


# Route Table Private
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_fiap.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "ecs-private-rt" }
}

resource "aws_route_table_association" "rt_private_association_0" {
  subnet_id      = aws_subnet.subnet_private[0].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_association_1" {
  subnet_id      = aws_subnet.subnet_private[1].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_private_association_2" {
  subnet_id      = aws_subnet.subnet_private[2].id
  route_table_id = aws_route_table.rt_private.id
}


# -------------------------------
# Security Groups
# -------------------------------
# SG do Load Balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc_fiap.id
  name   = "lb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SG do ECS
resource "aws_security_group" "ecs_sg" {
  vpc_id      = aws_vpc.vpc_fiap.id
  description = "Allow HTTP access"
  name        = "ecs-sg"

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------
# ECS Cluster + Task + Service
# -------------------------------
resource "aws_ecs_cluster" "api_cluster" {
  name = "python-auth-api-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/python-auth-api"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "api_task" {
  family                   = "python-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.labRole
  task_role_arn            = var.labRole

  container_definitions = jsonencode([
    {
      name      = "python-api"
      image     = "273703201222.dkr.ecr.us-east-1.amazonaws.com/api_auth_repo:latest" # Substitua pela imagem
      essential = true
      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = var.region_default
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# -------------------------------
# Load Balancer + Target Group
# -------------------------------
resource "aws_lb" "api_lb" {
  name               = "api-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet_public[0].id, aws_subnet.subnet_public[1].id, aws_subnet.subnet_public[2].id]
}

resource "aws_lb_target_group" "api_tg" {
  name        = "api-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc_fiap.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

resource "aws_ecs_service" "api_service" {
  name            = "python-api-service"
  cluster         = aws_ecs_cluster.api_cluster.id
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_private[0].id, aws_subnet.subnet_private[1].id, aws_subnet.subnet_private[2].id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_tg.arn
    container_name   = "python-api"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.api_listener]
}

# -------------------------------
# Output
# -------------------------------
output "api_url" {
  value = aws_lb.api_lb.dns_name
}
