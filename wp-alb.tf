resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.subnet_a_public.id, aws_subnet.subnet_b_public.id]
}

resource "aws_alb_target_group" "wordpress_alb_tg" {
  name     = "wordpress-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_alb_listener" "wordpress_alb_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wordpress_alb_tg.arn
  }
}

# The glue that connects the ALB with the resoures in wp-asg.tf
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  alb_target_group_arn   = aws_alb_target_group.wordpress_alb_tg.arn
}

resource "aws_security_group" "allow_http" {
  name        = "allow-http"
  description = "Allow HTTP/S inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from world"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "wordpress_dns_name" {
  value = aws_lb.wordpress_alb.dns_name
}
