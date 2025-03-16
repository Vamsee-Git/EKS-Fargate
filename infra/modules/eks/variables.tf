variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}

variable "fargate_profile_name" {
  description = "The name of the Fargate profile"
  type        = string
}

variable "namespace" {
  description = "The namespace for the Fargate profile"
  type        = string
  default     = "default"
}
