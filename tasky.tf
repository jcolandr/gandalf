resource "kubernetes_deployment" "tasky" {
  metadata {
    name = "scalable-tasky-example"
    labels = {
      App = "ScalabletaskyExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalabletaskyExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalabletaskyExample"
        }
      }
      spec {
        container {
          image = "jeffthorne/tasky:latest"
          name  = "example"

          port {
            container_port = 80
          }

          env {
            name = "MONGODB_URI	"
            value = "mongodb://frodo:baggins@3.145.34.154:27017"
          }
          env {
            name = "SECRET_KEY	"
            value = "secret123"
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tasky" {
  metadata {
    name = "tasky-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.tasky.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}