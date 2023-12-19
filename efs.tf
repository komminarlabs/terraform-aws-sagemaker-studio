resource "aws_efs_backup_policy" "default" {
  file_system_id = aws_sagemaker_domain.default.home_efs_file_system_id

  backup_policy {
    status = "ENABLED"
  }
}
