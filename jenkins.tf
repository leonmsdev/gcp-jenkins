resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "4.4.1"

  values = [
    file("${path.module}/configs/jenkins-values.yml")
  ]
}