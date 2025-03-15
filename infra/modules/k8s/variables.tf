variable "kubeconfig" {
  description = "Kubeconfig for the Kubernetes provider"
  type        = map(string)
}

variable "namespace" {
  description = "The namespace for the resources"
  type        = string
  default     = "default"
}

variable "deployment_name" {
  description = "The name of the deployment"
  type        = string
}

variable "replicas" {
  description = "The number of replicas"
  type        = number
  default     = 1
}

variable "app_label" {
  description = "The label for the app"
  type        = string
}

variable "container_image" {
  description = "The container image"
  type        = string
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "container_port" {
  description = "The port the container exposes"
  type        = number
}

variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "service_port" {
  description = "The port the service exposes"
  type        = number
}

variable "service_type" {
  description = "The type of the service"
  type        = string
  default     = "ClusterIP"
}

variable "ingress_name" {
  description = "The name of the ingress"
  type        = string
}

variable "ingress_path" {
  description = "The path for the ingress"
  type        = string
}