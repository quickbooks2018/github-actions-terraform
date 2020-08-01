provider "aws" {
  region = "us-east-1"
}

### Backend ###
# S3
###############
resource "aws_s3_bucket" "backend" {
  region = "us-east-1"
  bucket = "cloudgeeks-backend"
  acl    = "private"

  tags = {
    Name        = "Terraform Backend"
    Environment = "Dev"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "cloudgeeks-backend"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}


#####
# Vpc
#####

module "vpc" {
  source = "../../modules/aws-vpc"

  vpc-location                        = "Virginia"
  namespace                           = "cloudgeeks.ca"
  name                                = "vpc"
  stage                               = "dev"
  map_public_ip_on_launch             = "true"
  total-nat-gateway-required          = "1"
  create_database_subnet_group        = "false"
  vpc-cidr                            = "10.11.0.0/16"
  vpc-public-subnet-cidr              = ["10.11.1.0/24","10.11.2.0/24"]
  vpc-private-subnet-cidr             = ["10.11.4.0/24","10.11.5.0/24"]
  vpc-database_subnets-cidr           = ["10.11.7.0/24", "10.11.8.0/24"]
}




