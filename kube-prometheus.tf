resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
  depends_on = [google_container_node_pool.main_workload]
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.prometheus
  version    = "9.3.1"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}