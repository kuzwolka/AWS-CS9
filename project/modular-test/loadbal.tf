resource "aws_lb_target_group_attachment" "alb-to-tg" {
  
}

resource "aws_lb_listener" "example-alblistner" {
  load_balancer_arn = aws_lb.example-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example-alb-tg.arn
  }
}

resource "aws_lb_target_group" "example-alb-tg" {
  name        = "example-alb-tg"
  port        = var.server_port
  protocol    = "HTTP"
  instance_id

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 5
    matcher = 200
    path = "/index.html"
    protocol = "HTTP"
    port = var.server_port
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb" "example-alb" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.alb-sg.id ]
  subnets            = data.aws_subnets.default.ids 

  tags = {
    Name = "example-alb"
  }
}

output "alb_dnsname" {
    value = aws_lb.example-alb.dns_name
}