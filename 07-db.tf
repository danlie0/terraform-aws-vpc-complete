resource "aws_db_subnet_group" "dbsubnet" {
  name       = "${var.env_name}-dbsubnet"
  subnet_ids = module.dev-secure_vpc.private_subnets
}


module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "4.3.0"

  name           = var.db_name
  engine         = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.09.2"

  vpc_id                     = module.dev-secure_vpc.vpc_id
  db_subnet_group_name       = aws_db_subnet_group.dbsubnet.name
  port                       = 3306
  publicly_accessible        = "false"
  storage_encrypted          = "true"
  username                   = "tiptonsysadmin"
  database_name              = "tiptondb"
  deletion_protection        = true
  auto_minor_version_upgrade = false
  preferred_backup_window    = "04:00-05:00"
  backup_retention_period    = 15
  copy_tags_to_snapshot      = true

  replica_count          = 1
  create_security_group  = false
  vpc_security_group_ids = [aws_security_group.TEST-dev-rds-sg.id]
  instance_type          = "db.t3.medium"
  apply_immediately      = true
  monitoring_interval    = 10

  db_parameter_group_name         = aws_db_parameter_group.aurora_mysql_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_mysql_parameter_group.id

  tags = local.common_tags
}

resource "aws_db_parameter_group" "aurora_mysql_parameter_group" {
  name        = "aurora-db-mysql-parameter-group"
  family      = "aurora-mysql5.7"
  description = "aurora-db-mysql-parameter-group"

  parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
  }

}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_mysql_parameter_group" {
  name        = "aurora-mysql-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "aurora-mysql-cluster-parameter-group"

}

output "this_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = module.aurora.this_rds_cluster_id
}

output "this_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = module.aurora.this_rds_cluster_resource_id
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.this_rds_cluster_endpoint
}

output "this_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora.this_rds_cluster_reader_endpoint
}

output "this_rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.aurora.this_rds_cluster_database_name
}

output "this_rds_cluster_master_password" {
  description = "The master password"
  value       = module.aurora.this_rds_cluster_master_password
  sensitive   = true
}

output "this_rds_cluster_port" {
  description = "The port"
  value       = module.aurora.this_rds_cluster_port
}

output "this_rds_cluster_master_username" {
  description = "The master username"
  value       = module.aurora.this_rds_cluster_master_username
  sensitive   = true
}

// aws_rds_cluster_instance
output "this_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = module.aurora.this_rds_cluster_instance_endpoints
}

// aws_security_group
output "this_security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.aurora.this_security_group_id
}

