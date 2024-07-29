resource "aws_db_instance" "rds" {
  allocated_storage    = var.main_allocated_storage
  engine               = var.main_db_engine
  engine_version       = var.main_db_version
  instance_class       = var.main_db_instance_class
  username             = var.main_db_username
  password             = "testtest"
  parameter_group_name = var.parameter_group_name
#   availability_zone = "eu-west-1"
  skip_final_snapshot = true
  multi_az             = true
  # final_snapshot_identifier = "example-final-snapshot"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  backup_retention_period = 7
}
resource "aws_security_group" "rds_sg" {
  name        = var.sg_name
  vpc_id      = var.sg_vpc_id

  ingress {
    from_port   = var.sg_ingress_from_port
    to_port     = var.sg_ingress_to_port
    protocol    = var.sg_protocol
    cidr_blocks = var.cidr
  }
  
}

resource "aws_db_instance" "rds_replica" {
  count = var.replica_count
  replicate_source_db  = aws_db_instance.rds.identifier
  identifier           = "db-instance-replica-${count.index}"
  instance_class       = var.replica_instance_class
  skip_final_snapshot  = true
  availability_zone    = element(var.rds_replica_azs,count.index)
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  backup_retention_period = 7
}