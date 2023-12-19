variable "name" {
  type        = string
  description = "The name for the sagemaker resources"
}

variable "app_network_access_type" {
  type        = string
  default     = "VpcOnly"
  description = "Specifies the VPC used for non-EFS traffic"

  validation {
    condition     = contains(["PublicInternetOnly", "VpcOnly"], var.app_network_access_type)
    error_message = "Allowed values for app_network_access_type are \"PublicInternetOnly\" or \"VpcOnly\"."
  }
}

variable "auth_mode" {
  type        = string
  default     = "IAM"
  description = "The mode of authentication that members use to access the domain"

  validation {
    condition     = contains(["IAM", "SSO"], var.auth_mode)
    error_message = "Allowed values for auth_mode are \"IAM\" or \"SSO\"."
  }
}

variable "lcc_python_kernel" {
  type        = string
  default     = null
  description = "Specifies the custom lifecycle config file"
}

variable "role_arn" {
  type        = string
  default     = null
  description = "The arn of the IAM role to use for sagemaker"
}

variable "security_groups" {
  type        = list(string)
  default     = null
  description = "The security groups"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet ids"
}

variable "user_profiles" {
  type        = list(string)
  default     = []
  description = "The subnet ids"
}

variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources"
}
