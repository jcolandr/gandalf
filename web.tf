resource "kubernetes_deployment" "node" {
  metadata {
    name = "scalable-node-example"
    labels = {
      App = "ScalablenodeExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalablenodeExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalablenodeExample"
        }
      }
      spec {
        container {
          image = "jcolandro/taskapp:1.0"
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

resource "kubernetes_service" "node" {
  metadata {
    name = "node-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.node.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}