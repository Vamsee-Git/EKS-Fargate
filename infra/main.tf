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

data "aws_eks_cluster" "example" {
  name = module.eks.cluster_name

  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster_auth" "example" {
  name = module.eks.cluster_name

  depends_on = [
    module.eks
  ]
}

module "k8s" {
  source = "./modules/k8s"

  kubeconfig = {
    host                   = data.aws_eks_cluster.example.endpoint
    token                  = data.aws_eks_cluster_auth.example.token
    cluster_ca_certificate = data.aws_eks_cluster.example.certificate_authority[0].data
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
