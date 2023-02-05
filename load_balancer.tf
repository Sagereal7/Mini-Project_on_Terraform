# Create an Application Load Balancer

resource "aws_lb" "mini_terra_load_balancer" {
  name               = "mini-terra-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mini_terra_load_balancer_sg.id]
  subnets            = [aws_subnet.mini_terra_public_subnet1.id, aws_subnet.mini_terra_public_subnet2.id]
  #enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.mini_terra1, aws_instance.mini_terra2, aws_instance.mini_terra3]
}

# Create the target group

resource "aws_lb_target_group" "mini_terra_target_group" {
  name     = "mini-terra-target-group"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mini_terra_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create the listener

resource "aws_lb_listener" "mini_terra_listener" {
  load_balancer_arn = aws_lb.mini_terra_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mini_terra_target_group.arn
  }
}
# Create the listener rule
resource "aws_lb_listener_rule" "mini_terra_listener_rule" {
  listener_arn = aws_lb_listener.mini_terra_listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mini_terra_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach the target group to the load balancer

resource "aws_lb_target_group_attachment" "mini_terra_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.mini_terra_target_group.arn
  target_id        = aws_instance.mini_terra1.id
  port             = 80
}
 
resource "aws_lb_target_group_attachment" "mini_terra_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.mini_terra_target_group.arn
  target_id        = aws_instance.mini_terra2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "mini_terra_target_group_attachment3" {
  target_group_arn = aws_lb_target_group.mini_terra_target_group.arn
  target_id        = aws_instance.mini_terra3.id
  port             = 80 
  
  }

