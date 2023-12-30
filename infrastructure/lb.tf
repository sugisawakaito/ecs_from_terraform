resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  subnets            = [aws_subnet.public-1a.id, aws_subnet.public-1c.id]
  security_groups    = [aws_security_group.alb-sg.id, aws_vpc.vpc.default_security_group_id]
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "ecs-tg" {
  name                          = "ecs-tg"
  load_balancing_algorithm_type = "round_robin"
  port                          = 80
  protocol                      = "HTTP"
  target_type                   = "ip"
  vpc_id                        = aws_vpc.vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

}

resource "aws_lb_target_group" "ecs-8070-tg" {
  name                          = "ecs-8070-tg"
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = aws_vpc.vpc.id
  target_type                   = "ip"
  ip_address_type               = "ipv4"
  load_balancing_algorithm_type = "round_robin"
}


resource "aws_lb_listener" "alb-80-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb-443-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:ap-northeast-1:284908758499:certificate/380c26be-627e-4b4a-9317-7c5f9c03786f"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg.arn
  }
}

resource "aws_lb_listener_rule" "alb-to-api-listener" {
  listener_arn = aws_lb_listener.alb-443-listner.arn
  action {
    order            = 1
    target_group_arn = aws_lb_target_group.ecs-8070-tg.arn
    type             = "forward"
  }
  condition {
    path_pattern {
      values = ["/api"]
    }
  }
}