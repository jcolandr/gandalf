resource "kubernetes_deployment" "flask" {
  metadata {
    name = "scalable-flask-example"
    labels = {
      App = "ScalableflaskExample"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "ScalableflaskExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableflaskExample"
        }
      }
      spec {
        container {
          image = "jcolandro/taskapp:1.3"
          name  = "web"

          port {
            container_port = 5000
          }

          # env {
          #   name = "MONGO_HOST"
          #   value = "3.145.34.154"
          # }
          
          # env {
          #   name = "MONGO_PORT"
          #   value = "27017"
          # }

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

resource "kubernetes_service" "flask" {
  metadata {
    name = "flask-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}