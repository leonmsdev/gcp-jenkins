resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  version    = "47.0.0"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}

# resource "kubernetes_ingress" "grafana" {
#   metadata {
#     name = "grafana-ingress"
#     namespace = kubernetes_namespace.prometheus.metadata[0].name
#   }

#   spec {
#     rule {
#       host = local.dns_name
#       http {
#         path {
#           backend {
#             service_name = "kube-prometheus-stack-grafana"
#             service_port = 80
#           }
#           path = "/"
#         }
#       }
#     }
#   }
# }