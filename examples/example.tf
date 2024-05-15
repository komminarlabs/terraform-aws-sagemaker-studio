terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "example_studio" {
  source                  = "github.com/komminarlabs/terraform-aws-sagemaker-studio?ref=v1.0.0"
  name                    = "example-studio"
  app_network_access_type = "VpcOnly"
  subnet_ids              = aws_subnet.private[*].id
  vpc_id                  = aws_vpc.default.id

  user_profiles = [
    "user-1",
    "user-2",
  ]

  tags = {
    Environment = "development"
    Stack       = "sagemaker"
  }
}
