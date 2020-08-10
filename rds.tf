resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet_a_private.id, aws_subnet.subnet_b_private.id]
}

resource "aws_db_instance" "wp_mysql_db" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "wpdb"
  username               = "wordpressdb"
  password               = "changeme"
  parameter_group_name   = "default.mysql5.7"
  multi_az               = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]

}

resource "aws_security_group" "allow_mysql" {
  name        = "allow-mysql"
  description = "Allow Mysql inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL from local"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
