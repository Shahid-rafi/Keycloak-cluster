resource "aws_lb" "keycloak-ALB2" {
  name               = "Keycloak-ALB-2"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = ["subnet-05baf095df2533340", "subnet-02b72e3da7010c8c6", "subnet-0ba6fda0976e5fa6f"]
}

resource "aws_lb_target_group" "keycloak-TG" {
  name        = "keycloak-target"
  port        = 8080
  protocol    = "HTTP"
  vpc_id = "vpc-0e74eeb6473652b5e"
  health_check {
    interval    = 300
    path        = "/auth/"
  }
  target_type = "ip"
  #vpc_id      = aws_default_vpc.default.vpc_id
}

resource "aws_lb_listener" "keycloak-listener" {
  #name              = "keycloak-listener"
  load_balancer_arn = aws_lb.keycloak-ALB2.arn
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_lb.keycloak-ALB2, aws_lb_target_group.keycloak-TG]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.keycloak-TG.arn
  }

}