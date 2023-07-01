resource "aws_ecs_task_definition" "keycloak-task" {
  family                   = "keycloak-terraform"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = file("C:\\Users\\0029AO744\\Desktop\\Learning\\Terraform\\Learning\\keycloak\\container.json")
  task_role_arn = "arn:aws:iam::918412845035:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::918412845035:role/ecsTaskExecutionRole"

#   runtime_platform {
#     operating_system_family = "linux"
#     cpu_architecture        = "X86_64"
#   }
}

resource "aws_ecs_cluster" "keycloak-cluster" {
  name = "keycloak-terrafom-cluster"
}

resource "aws_ecs_service" "keycloak-service" {
    name = "keycloak-terraform-service-1"
    cluster = aws_ecs_cluster.keycloak-cluster.id
    task_definition = aws_ecs_task_definition.keycloak-task.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
      subnets = ["subnet-05baf095df2533340", "subnet-02b72e3da7010c8c6", "subnet-0ba6fda0976e5fa6f"]
      assign_public_ip = true
      security_groups = [aws_security_group.ecs.id]
    }
    load_balancer {
      target_group_arn = aws_lb_target_group.keycloak-TG.arn
      container_name = "keycloak"
      container_port = 8080
    }
}