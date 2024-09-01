terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.20.0"  # Optional: specify the version you want to use
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#run terraform providers command to check version just for provider version identification


### ----- below example for specifi version range we can take ---- ####
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 4.10.0, < 5.0.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }
