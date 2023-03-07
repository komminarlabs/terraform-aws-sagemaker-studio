output "domain" {
  description = "The attributes of the sagemaker domain"
  value       = aws_sagemaker_domain.default
}

output "user_profile" {
  description = "The attributes of the users of sagemaker domain"
  value       = aws_sagemaker_user_profile.default
}
