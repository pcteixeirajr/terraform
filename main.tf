data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

locals {
  name   = "vrs-propostas-empresas-db"
  region = var.region

  tags = {
    squad    = "squad-portais"
    resource  = "rds-aurora-postgres"
    environment = var.environment

  }
}

data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "14.5"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.name_vpc}"]
  }
}

################################################################################
# RDS vrs-propostas-empresas-db
################################################################################
module "vrs_propostas_empresas_db" {

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.2.0"

  name              = local.name
  engine            = data.aws_rds_engine_version.postgresql.engine
  engine_mode       = "provisioned"
  storage_encrypted = true
  master_username   = "vrs_propostas_empresas"

  vpc_id               = data.aws_vpc.vpc.id
  db_subnet_group_name = var.db_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = var.cidr_blocks
    }
  }

  manage_master_user_password = false
  master_password             = "Vinci!2023"

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 1
  }

  instance_class = "db.serverless"
  instances = {
    one = {
      identifier = "vrs-propostas-empresas-instance"
      publicly_accessible = false
    }
  }

  tags = local.tags
}
