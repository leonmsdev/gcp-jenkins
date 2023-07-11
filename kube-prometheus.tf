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

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = kubernetes_namespace.prometheus.metadata[0].name
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "grafana.leonschmidt-cloud.com"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port = {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}