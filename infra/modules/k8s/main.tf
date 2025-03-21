provider "kubernetes" {
  host                   = var.kubeconfig["host"]
  token                  = var.kubeconfig["token"]
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

          readiness_probe {
            http_get {
              path = "/"
              port = var.container_port
            }
            initial_delay_seconds = 5
            period_seconds        = 10
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
