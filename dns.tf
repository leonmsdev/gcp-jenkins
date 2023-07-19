locals {
  dns_zone_name = "leonschmidt"
  dns_domain    = "leonschmidt.cloud"
  a_records = [
    "nginx",
    "grafana",
  ]
}

resource "google_dns_managed_zone" "leonschmidt_cloud" {
  name        = format("%s-cloud", local.dns_zone_name)
  dns_name    = format("%s.cloud.", local.dns_zone_name)
  description = format("%s DNS zone", local.dns_domain)
}

data "kubernetes_service" "ext_ingress_nginx" {
  metadata {
    name      = "ext-ingress-nginx-controller"
    namespace = kubernetes_namespace.ext_ingress_nginx.metadata[0].name
  }
}

resource "google_dns_record_set" "nginx_a_record_leonschmidt_cloud" {
  for_each = toset(local.a_records)
  name     = format("%s.%s", each.key, google_dns_managed_zone.leonschmidt_cloud.dns_name)
  type     = "A"
  ttl      = 300

  managed_zone = google_dns_managed_zone.leonschmidt_cloud.name

  rrdatas = [data.kubernetes_service.ext_ingress_nginx.status[0].load_balancer[0].ingress[0].ip]
}