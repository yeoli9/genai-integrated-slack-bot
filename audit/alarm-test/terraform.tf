terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
    bucket  = "yeoli-terraform-backend"
    key     = "aws/assistance/notification/audit/alarm-test"
    region  = "ap-northeast-2"
    profile = "yeoli"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "yeoli"
  default_tags {
    tags = {
      service = "assistance"
      env     = "prod"
    }
  }
}
