module "example_studio" {
  source                  = "github.com/komminar/terraform-aws-sagemaker-studio?ref=v1.0.0"
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
