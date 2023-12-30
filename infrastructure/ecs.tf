
resource "aws_ecs_cluster" "cluster" {
  name = "cluster"
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  service_connect_defaults {
    # namespace = aws_service_discovery_private_dns_namespace.cluster.arn
    namespace = aws_service_discovery_private_dns_namespace.namespace.arn
  }
}

resource "aws_ecs_task_definition" "rest-api" {
  family             = "rest-api"
  cpu                = "1024"
  memory             = "3072"
  execution_role_arn = "arn:aws:iam::284908758499:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::284908758499:role/ecsTaskRole"
  requires_compatibilities = [
    "FARGATE",
  ]
  network_mode = "awsvpc"


  container_definitions = jsonencode([
    {
      cpu              = 0
      environment      = []
      environmentFiles = []
      essential        = true
      image            = "284908758499.dkr.ecr.ap-northeast-1.amazonaws.com/rest-api:latest"
      mountPoints      = []
      name             = "rest-api"
      # logConfiguration = {
      #   logDriver = "awslogs",
      #   options = {
      #     awslogs-region        = "ap-northeast-1",
      #     awslogs-stream-prefix = "web",
      #     awslogs-group         = "/ecs/project/dev/web"
      #   }
      # },
      portMappings = [
        {
          appProtocol   = "http"
          containerPort = 8080
          hostPort      = 8080
          name          = "rest-api-8080-tcp"
          protocol      = "tcp"
        },
      ]
      ulimits     = []
      volumesFrom = []
    },
  ])
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

}


resource "aws_ecs_task_definition" "task" {
  family             = "task"
  cpu                = "1024"
  memory             = "3072"
  execution_role_arn = "arn:aws:iam::284908758499:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::284908758499:role/ecsTaskRole"
  requires_compatibilities = [
    "FARGATE",

  ]
  network_mode = "awsvpc"


  container_definitions = jsonencode([
    {
      cpu              = 0
      environment      = []
      environmentFiles = []
      essential        = true
      image            = "284908758499.dkr.ecr.ap-northeast-1.amazonaws.com/backend:latest"
      mountPoints      = []
      name             = "backend"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = "ap-northeast-1",
          awslogs-stream-prefix = "web",
          awslogs-group         = "/ecs/project/dev/web"
        }
      },
      portMappings = [
        {
          appProtocol   = "http"
          containerPort = 8080
          hostPort      = 8080
          name          = "backend-8080-tcp"
          protocol      = "tcp"
        },
      ]
      ulimits     = []
      volumesFrom = []
    },
    {
      cpu              = 0
      environment      = []
      environmentFiles = []
      essential        = false
      image            = "284908758499.dkr.ecr.ap-northeast-1.amazonaws.com/webapp:latest"
      mountPoints      = []
      name             = "webapp"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region        = "ap-northeast-1",
          awslogs-stream-prefix = "web",
          awslogs-group         = "/ecs/project/dev/app"
        }
      },
      portMappings = [
        {
          containerPort = 8070
          hostPort      = 8070
          name          = "webapp-8070-tcp"
          protocol      = "tcp"
        },
      ]
      volumesFrom = []
    }
  ])
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

}

# resource "aws_ecs_service" "sevice" {
#   name            = "service"
#   cluster         = aws_ecs_cluster.cluster.id
#   task_definition = aws_ecs_task_definition.task.arn
#   desired_count   = 2
#   # iam_role        = "arn:aws:iam::284908758499:role/ecsTaskRole"
#   launch_type = "FARGATE"


#   # load_balancer {
#   #   # elb_name          = aws_lb.alb.name
#   #   target_group_arn = aws_lb_target_group.alb-tg.arn
#   #   container_name   = "backend"
#   #   container_port   = 8080
#   # }

#   network_configuration {
#     subnets = [
#       aws_subnet.public-1a.id,
#       aws_subnet.public-1c.id,
#     ]
#     security_groups = [
#       aws_vpc.vpc.default_security_group_id,
#       aws_security_group.ecs-sg.id
#     ]
#     assign_public_ip = false
#   }
# }

resource "aws_ecs_service" "service-1" {
  cluster                 = aws_ecs_cluster.cluster.id
  task_definition         = aws_ecs_task_definition.task.arn
  enable_ecs_managed_tags = true
  desired_count           = 2
  launch_type             = "FARGATE"
  name                    = "service-1"

  # deployment_circle_breaker {
  #   enable   = true
  #   rollback = true
  # }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-8070-tg.arn
    container_name   = "webapp"
    container_port   = 8070
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-tg.arn
    container_name   = "backend"
    container_port   = 8080
  }

  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs-sg.id,
      aws_vpc.vpc.default_security_group_id
    ]
    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1c.id
    ]
  }
}

resource "aws_ecs_service" "rest-api" {
  name                    = "rest-api"
  cluster                 = aws_ecs_cluster.cluster.id
  task_definition         = aws_ecs_task_definition.rest-api.arn
  enable_ecs_managed_tags = true
  desired_count           = 2
  launch_type             = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.rest-api.arn
    # port         = 8080
    # container_name = "rest-api"
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs-sg.id,
      aws_vpc.vpc.default_security_group_id
    ]
    subnets = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1c.id
    ]
  }
}