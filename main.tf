locals {
  lcc_python_kernel = var.lcc_python_kernel != null ? var.lcc_python_kernel : "${path.module}/scripts/lcc_jupyter_server.sh"
}

resource "aws_sagemaker_domain" "default" {
  domain_name             = var.name
  app_network_access_type = var.app_network_access_type
  auth_mode               = var.auth_mode
  subnet_ids              = var.subnet_ids
  vpc_id                  = var.vpc_id
  tags                    = var.tags

  default_user_settings {
    execution_role  = var.role_arn != null ? var.role_arn : aws_iam_role.default[0].arn
    security_groups = var.security_groups

    jupyter_server_app_settings {
      lifecycle_config_arns = [aws_sagemaker_studio_lifecycle_config.jupyter.arn]

      default_resource_spec {
        instance_type        = "system"
        lifecycle_config_arn = aws_sagemaker_studio_lifecycle_config.jupyter.arn
      }
    }
  }
}

resource "aws_sagemaker_studio_lifecycle_config" "jupyter" {
  studio_lifecycle_config_name     = "lcc-jupyter-server-autoshutdown"
  studio_lifecycle_config_app_type = "JupyterServer"
  studio_lifecycle_config_content  = filebase64("${path.module}/scripts/lcc_jupyter_server_autoshutdown.sh")
  tags                             = var.tags
}

resource "aws_sagemaker_user_profile" "default" {
  for_each          = { for user in var.user_profiles : user => true }
  domain_id         = aws_sagemaker_domain.default.id
  user_profile_name = each.key
  tags              = var.tags

  user_settings {
    execution_role  = var.role_arn != null ? var.role_arn : aws_iam_role.default[0].arn
    security_groups = var.security_groups
  }
}
