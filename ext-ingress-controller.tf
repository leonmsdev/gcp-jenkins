resource "kubernetes_namespace" "ext_ingress_nginx" {
  metadata {
    name = "ext-nginx-ingress"
  }
}

resource "helm_release" "ext_ingress_nginx" {
  name       = "ext"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ext_ingress_nginx.metadata[0].name
  version    = ">=3.0.0"

  values = [
    file("${path.module}/configs/ext-nginx-values.yml")
  ]
}