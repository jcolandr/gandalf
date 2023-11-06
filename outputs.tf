# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

# output "region" {
#   description = "AWS region"
#   value       = var.region
# }

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "instance_public_ip" {
  value = aws_instance.mongo.public_ip
}

output "instance_internal_ip" {
  value = aws_instance.mongo.private_ip
}

output "nginx_ip" {
  value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
}

output "node_ip" {
  value = kubernetes_service.node.status.0.load_balancer.0.ingress.0.hostname
}