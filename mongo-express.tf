resource "kubernetes_deployment" "mongoexpress" {
  metadata {
    name = "scalable-mongoexpress-example"
    labels = {
      App = "ScalablemongoexpressExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalablemongoexpressExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalablemongoexpressExample"
        }
      }
      spec {
        container {
          image = "mongo-express"
          name  = "mongo-express"

          port {
            container_port = 8081
          }

          env {
            name = "ME_CONFIG_MONGODB_SERVER"
            value = "3.145.34.154"
          }
          
          env {
            name = "MONGME_CONFIG_MONGODB_ADMINUSERNAMEO_PORT"
            value = "frodo"
          }

          env {
            name = "ME_CONFIG_MONGODB_ADMINPASSWORD"
            value = "baggins"
          }

          # resources {
          #   limits = {
          #     cpu    = "0.5"
          #     memory = "512Mi"
          #   }
          #   requests = {
          #     cpu    = "250m"
          #     memory = "50Mi"
          #   }
          # }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongoexpress" {
  metadata {
    name = "mongo-express"
  }
  spec {
    selector = {
      App = kubernetes_deployment.mongoexpress.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8081
      target_port = 8081
    }

    type = "LoadBalancer"
  }
}