resource "aws_db_instance" "wp_mysql_db" {
    allocated_storage    = 10
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    name                 = "wpdb"
  # username             = 
  # password             = 
    parameter_group_name = "default.mysql5.7"
    multi_az             = true
}
