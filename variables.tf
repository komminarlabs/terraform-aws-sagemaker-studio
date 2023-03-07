variable "name" {
  type        = string
  description = "The name for the sagemaker resources"
}

variable "app_network_access_type" {
  type        = string
  default     = "PublicInternetOnly"
  description = "Specifies the VPC used for non-EFS traffic"
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
