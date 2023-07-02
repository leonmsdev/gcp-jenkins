import {
  to = kubernetes_namespace.dependabot
  id = random_integer.import_id.result
}

resource "random_integer" "import_id" {
  byte_length = 4
}

resource "kubernetes_namespace" "dependabot" {
  metadata {
    name = "dependabot"
  }
}