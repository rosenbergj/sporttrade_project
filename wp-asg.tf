resource "aws_launch_template" "wordpress" {
  name_prefix            = "wp-"
  image_id               = "ami-0d05d2a692214ce9f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_from_local.id]
}

resource "aws_autoscaling_group" "wordpress_asg" {
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.subnet_a_protected.id, aws_subnet.subnet_b_protected.id]

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}

resource "aws_security_group" "allow_http_from_local" {
  name        = "allow-http-from-local"
  description = "Allow HTTP/S inbound traffic from local network"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from local"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "HTTPS from local"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
