provider "aws" {
  region = "us-east-1"
  alias = "east"
}


provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.59.0"
    }
  }
}
