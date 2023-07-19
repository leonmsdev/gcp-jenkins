resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.12.0"

  namespace  = kubernetes_namespace.cert_manager.metadata.0.name
  depends_on = [kubernetes_namespace.cert_manager]

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_manifest" "cluster_issuer_letsencrypt" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt"
    }
    "spec" = {
      "acme" = {
        "email" = "leonms.dev@gmail.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-account-key"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "certificate" {
  count = length(local.ext_entrys)
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "cert-tls"
      "namespace" = local.ext_entrys[count.index].key
    }
    "spec" = {
      "commonName" = format("%s.leonschmidt.cloud", local.ext_entrys[count.index].value)
      "dnsNames" = [
        format("%s.leonschmidt.cloud", local.ext_entrys[count.index].value)
      ]
      "issuerRef" = {
        "kind" = "ClusterIssuer"
        "name" = "letsencrypt"
      }
      "secretName" = "cert-tls"
    }
  }
}

# resource "kubernetes_manifest" "grafana_certificate" {
#   manifest = {
#     "apiVersion" = "cert-manager.io/v1"
#     "kind"       = "Certificate"
#     "metadata" = {
#       "name"      = "grafana-tls"
#       "namespace" = "prometheus"
#     }
#     "spec" = {
#       "commonName" = "grafana.leonschmidt.cloud"
#       "dnsNames" = [
#         "grafana.leonschmidt.cloud",
#       ]
#       "issuerRef" = {
#         "kind" = "ClusterIssuer"
#         "name" = "letsencrypt"
#       }
#       "secretName" = "grafana-tls"
#     }
#   }
# }