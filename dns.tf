locals {
  dns_name = "leonschmidt-cloud"
}

resource "google_dns_managed_zone" "leonschmidt_cloud" {
  name        = local.dns_name
  dns_name    = format("%s.com.", local.dns_name)
  description = format("%s DNS zone", local.dns_name)
}

data "kubernetes_service" "ext_ingress_nginx" {
  metadata {
    name      = "ext-ingress-nginx-controller"
    namespace = kubernetes_namespace.ext_ingress_nginx.metadata[0].name
  }
}

resource "google_dns_record_set" "a_record_leonschmidt_cloud" {
  name = format("grafana.%s", google_dns_managed_zone.leonschmidt_cloud.dns_name)
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.leonschmidt_cloud.name

  rrdatas = [data.kubernetes_service.ext_ingress_nginx.status[0].load_balancer[0].ingress[0].ip]
}