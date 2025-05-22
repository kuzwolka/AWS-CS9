#----------Target Group----------------------------------
resource "aws_lb_target_group_attachment" "alb-to-tg" {
  count    = var.lb_type == "application" ? 1 : 0
  for_each = {
    for idx, inst in aws_instance.web2 :
    idx => inst
  }

  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = each.value.id
  port             = var.server_port
}

resource "aws_lb_target_group_attachment" "alb-to-tg" {
  count    = var.lb_type == "network" ? 1 : 0
  for_each = {
    for idx, inst in aws_instance.web2 :
    idx => inst
  }

  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id        = each.value.id
  port             = var.server_port
}

#----------------lb-listner--------------------
resource "aws_lb_listener" "alb-listner" {
  count    = var.lb_type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener" "nlb-listner" {
  count    = var.lb_type == "network" ? 1 : 0
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}

#-----------target group---------------------
resource "aws_lb_target_group" "alb-tg" {
  count     = var.lb_type == "application" ? 1 : 0
  name        = "${var.user_name}-lb-tg"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id = aws_vpc.test.id

  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 5
    matcher = 200
    path = var.health_path
    protocol = "HTTP"
    port = var.server_port
    timeout = 2
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  count     = var.lb_type == "network" ? 1 : 0
  name      = "${var.user_name}-nlb-tg"
  port      = var.server_port
  protocol  = "TCP"
  vpc_id    = aws_vpc.test.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    protocol            = "TCP"
    port                = var.server_port
    timeout             = 5
    unhealthy_threshold = 3
  }
}

resource "aws_lb" "lb" {
  name               = "${var.user_name}-lb"
  internal           = false
  load_balancer_type = var.lb_type
  subnets = [ for subnet in aws_subnet.public_subnets : subnet.id ]

  dynamic "alb-security_groups" {
    for_each = var.lb_type == "application" ? [1] : []
    content {
      security_groups = [ aws_security_group.alb-sg.id ]
    }
  }

  dynamic "network-lb-acl" {
    for_each = var.lb_type == "network" ? [1] : []
  }

  tags = {
    Name = "${var.user_name}-lb"
  }
}

resource "aws_security_group" "alb-sg" {
  name        = "${var.user_name}-lb-sg"
  description = "security group for lb"

  ingress {
    description      = "Allow TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.user_name}-alb-sg"
  }
}