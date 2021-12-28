##############################################################
# Terraform
##############################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }


    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}


##########################################################
#  Provider
###########################################################


provider "aws" {
  region  = var.region
  profile = var.profile
}


