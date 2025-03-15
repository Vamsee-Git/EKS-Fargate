provider "kubernetes" {
  host                   = var.kubeconfig["host"]
  client_certificate     = base64decode(var.kubeconfig["client_certificate"])
  client_key             = base64decode(var.kubeconfig["client_key"])
  cluster_ca_certificate = base64decode(var.kubeconfig["cluster_ca_certificate"])
}

resource "kubernetes_deployment" "example" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_label
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.container_name

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      port        = var.service_port
      target_port = var.container_port
    }

    type = var.service_type
  }
}

resource "kubernetes_ingress" "example" {
  metadata {
    name      = var.ingress_name
    namespace = var.namespace
  }

  spec {
    rule {
      http {
        path {
          path = var.ingress_path

          backend {
            service_name = kubernetes_service.example.metadata[0].name
            service_port = var.service_port
          }
        }
      }
    }
  }
}