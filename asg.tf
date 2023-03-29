
//ami
resource "aws_ami_from_instance" "ami" {
  name  = "${var.prefix}ec2"
  source_instance_id = aws_instance.web.id
  depends_on = [aws_instance.web]
}
//asg
resource "aws_launch_template" "template" {
  name = "${var.prefix}ec2"
  image_id   = aws_ami_from_instance.ami.id
  instance_type = "t2.micro"
  iam_instance_profile {
    name="ec2-acces-s3"
  } 
  key_name = "${var.prefix}ec2"
  vpc_security_group_ids = [aws_security_group.sgweb.id]
  depends_on = [aws_ami_from_instance.ami]
}
resource "aws_autoscaling_group" "asg" {
  name="${var.prefix}asg"

  desired_capacity   = 1
  max_size           = 3
  min_size           = 1
  
  //health_check 但不確定有沒有必要
  health_check_grace_period = 300
  health_check_type  = "ELB"
 

  vpc_zone_identifier  = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  
  launch_template {
    id = aws_launch_template.template.id
    version = "$Latest"
  }
  
  tag {
    key  = "Name"
    value  = "${var.prefix}asg"
    propagate_at_launch = true
  }
  
  lifecycle {
    create_before_destroy = true
  }
  
}

//targetgroup
resource "aws_lb_target_group" "tg" {
  name     = "${var.prefix}tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
//webec2綁tg
resource "aws_lb_target_group_attachment" "target" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
//asg綁tg
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn  = aws_lb_target_group.tg.arn
  
  depends_on = [aws_lb_target_group.tg]
}
