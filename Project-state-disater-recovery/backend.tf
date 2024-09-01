terraform {
  backend "s3" {
    bucket         = "primary-terraform-state-bucket"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
