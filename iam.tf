data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
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
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/*"]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"

      values = [
        "sagemaker.amazonaws.com",
        "events.amazonaws.com",
      ]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "events:TagResource",
      "events:DeleteRule",
      "events:PutTargets",
      "events:DescribeRule",
      "events:PutRule",
      "events:RemoveTargets",
      "events:DisableRule",
      "events:EnableRule",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/sagemaker:is-scheduling-notebook-job"
      values   = ["true"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::sagemaker-automated-execution-*"]

    actions = [
      "s3:CreateBucket",
      "s3:PutBucketVersioning",
      "s3:PutEncryptionConfiguration",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:sagemaker:*:*:user-profile/*",
      "arn:aws:sagemaker:*:*:space/*",
      "arn:aws:sagemaker:*:*:training-job/*",
      "arn:aws:sagemaker:*:*:pipeline/*",
    ]

    actions = ["sagemaker:ListTags"]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:sagemaker:*:*:training-job/*",
      "arn:aws:sagemaker:*:*:pipeline/*",
    ]

    actions = ["sagemaker:AddTags"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

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
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetEncryptionConfiguration",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject",
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
  }
}

resource "aws_iam_role" "default" {
  count              = var.role_arn == null ? 1 : 0
  name               = "SageMakerRole-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "default" {
  count  = var.role_arn == null ? 1 : 0
  name   = "SageMakerRole-${var.name}"
  role   = aws_iam_role.default[0].id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.role_arn == null ? 1 : 0
  role       = aws_iam_role.default[0].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
