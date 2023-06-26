resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  version    = "47.0.0"
  repository = "https://github.com/prometheus-operator/kube-prometheus"
  chart      = "kube-prometheus-stack"
}