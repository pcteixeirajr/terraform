provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/PipelineIasC"
    session_name = "PipelineIasC"
    external_id = var.account_external_id 
  }
}

terraform {
  backend "s3" {}
}
