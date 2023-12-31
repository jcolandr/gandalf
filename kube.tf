


data "aws_eks_cluster" "cluster" {
  name = "wizard-burial-ground"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

# resource "kubernetes_deployment" "dlogo" {
#   metadata {
#     name = "scalable-dlogo-example"
#     labels = {
#       App = "ScalabledlogoExample"
#     }
#   }

#   spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         App = "ScalabledlogoExample"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           App = "ScalabledlogoExample"
#         }
#       }
#       spec {
#         container {
#           image = "jcolandro/dlogo:1.5"
#           name  = "dlogo"

#           port {
#             container_port = 80
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "dlogo" {
#   metadata {
#     name = "dlogo-example"
#   }
#   spec {
#     selector = {
#       App = kubernetes_deployment.dlogo.spec.0.template.0.metadata[0].labels.App
#     }
#     port {
#       port        = 80
#       target_port = 80
#     }

#     type = "LoadBalancer"
#   }
# }


