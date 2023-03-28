
//alb
resource "aws_lb" "alb" {
  name               = "${var.prefix}alb"
  internal           = false 
  load_balancer_type = "application"
  security_groups  = [aws_security_group.sgalb.id]
  subnets = [aws_subnet.public[0].id,aws_subnet.public[1].id]

}
resource "aws_lb_listener" "listen" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.listen.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
