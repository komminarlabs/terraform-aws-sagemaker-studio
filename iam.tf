data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "sagemaker.amazonaws.com",
        "events.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "default" {
  statement {
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::*:role/*"]

    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["sagemaker.amazonaws.com"]
    }
  }

  statement {
    actions = ["sagemaker:ListTags"]

    resources = [
      "arn:aws:sagemaker:*:*:user-profile/*",
      "arn:aws:sagemaker:*:*:space/*",
      "arn:aws:sagemaker:*:*:training-job/*",
      "arn:aws:sagemaker:*:*:pipeline/*",
    ]
  }

  statement {
    actions = ["sagemaker:AddTags"]

    resources = [
      "arn:aws:sagemaker:*:*:training-job/*",
      "arn:aws:sagemaker:*:*:pipeline/*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateVpcEndpoint",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "sagemaker:DescribeDomain",
      "sagemaker:DescribeUserProfile",
      "sagemaker:DescribeSpace",
      "sagemaker:DescribeStudioLifecycleConfig",
      "sagemaker:DescribeImageVersion",
      "sagemaker:DescribeAppImageConfig",
      "sagemaker:CreateTrainingJob",
      "sagemaker:DescribeTrainingJob",
      "sagemaker:StopTrainingJob",
      "sagemaker:Search",
      "sagemaker:CreatePipeline",
      "sagemaker:DescribePipeline",
      "sagemaker:DeletePipeline",
      "sagemaker:StartPipelineExecution",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "default" {
  count              = var.role_arn == null ? 1 : 0
  name               = "SageMakerExecutionRole-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "default" {
  count  = var.role_arn == null ? 1 : 0
  name   = "SageMakerExecutionRole-${var.name}"
  role   = aws_iam_role.default[0].id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.role_arn == null ? 1 : 0
  role       = aws_iam_role.default[0].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
