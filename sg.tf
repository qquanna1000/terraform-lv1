resource "aws_security_group" "sgbastion" {
  name        = "sgbastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from local"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["59.124.14.121/32"] //限制公司的電腦才能進入ssm
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}bastion"
  }
}
resource "aws_security_group" "sgalb" {
  name        = "sgalb"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from everywhere  "
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
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}alb"
  }
}
resource "aws_security_group" "sgweb" {
  name = "sgweb"

  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP from ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.sgalb.id]
  }
  ingress {
    description = "ssh from bastion"
    from_port = 22
    to_port  = 22
    protocol= "tcp"
    security_groups = [aws_security_group.sgbastion.id]
  }
  

  egress {
    from_port  = 0
    to_port  = 0
    protocol = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}webec2"
  }
}
resource "aws_security_group" "sgdb" {
  name        = "sgdb"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTPs from webec2"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups     = [aws_security_group.sgweb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}db"
  }
}
resource "aws_security_group" "sgefs" {
  name        = "sgefs"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "allow efs"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] //限制公司的電腦才能進入ssm
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}bastion"
  }
}