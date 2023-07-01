resource "aws_db_instance" "default" {
  allocated_storage    = 20
  db_name              = "keycloak"
  engine               = "mysql"
  engine_version       = "8.0.32"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "admin1234"
  identifier           = "keycloak-db"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
}