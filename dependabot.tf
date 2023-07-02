import {
  to = kubernetes_namespace.dependabot
  id = "124ffx"
}

resource "kubernetes_namespace" "dependabot" {
  metadata {
    name = "dependabot"
  }
}