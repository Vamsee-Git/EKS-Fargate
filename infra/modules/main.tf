provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "eks" {
  source               = "./modules/eks"
  cluster_name         = "example-cluster"
  role_name            = "example-role"
  subnet_ids           = module.vpc.subnet_ids
  fargate_profile_name = "example-fargate-profile"
  namespace            = "default"
}

module "k8s" {
  source = "./modules/k8s"

  kubeconfig = {
    host                   = "https://example-cluster.us-west-2.eks.amazonaws.com"
    client_certificate     = filebase64("${path.module}/certs/client-cert.pem")
    client_key             = filebase64("${path.module}/certs/client-key.pem")
    cluster_ca_certificate = filebase64("${path.module}/certs/ca-cert.pem")
  }

  namespace        = "default"
  deployment_name  = "example-deployment"
  replicas         = 2
  app_label        = "example-app"
  container_image  = "nginx:latest"
  container_name   = "nginx"
  container_port   = 80
  service_name     = "example-service"
  service_port     = 80
  service_type     = "LoadBalancer"
  ingress_name     = "example-ingress"
  ingress_path     = "/"
}
