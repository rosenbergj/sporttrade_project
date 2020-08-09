resource "aws_launch_template" "wordpress" {
  name_prefix   = "wp-"
  image_id      = "ami-0d05d2a692214ce9f"
  instance_type = "t3.micro"
}

resource "aws_autoscaling_group" "wordpress_asg" {
  min_size           = 2
  max_size           = 4
  desired_capacity   = 2
  vpc_zone_identifier  = [aws_subnet.subnet_a_public.id, aws_subnet.subnet_b_public.id]

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}
