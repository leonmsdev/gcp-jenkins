locals {
  dns_zone_name = "leonschmidt"
  dns_domain    = "leonschmidt.cloud"
  ext_entrys = [
    # key = namespace / value = product and dns
    { "nginx" = "nginx" },
    { "prometheus" = "grafana" },
    { "jenkins" = "jenkins" },
  ]

  de_dns_zone_name = "hochzeitsautoschwerin"
  de_dns_domain    = "hochzeitsautoschwerin.de"
  de_entry = [
    { "hochzeitsautoschwerin" = "hochzeitsautoschwerin" },
  ]
}

resource "google_dns_managed_zone" "leonschmidt_cloud" {
  name        = format("%s-cloud", local.dns_zone_name)
  dns_name    = format("%s.cloud.", local.dns_zone_name)
  description = format("%s DNS zone", local.dns_domain)
}

#hochzeitsautoschwerin
resource "google_dns_managed_zone" "hochzeitsautoschwerin" {
  name        = format("%s-cloud", local.de_dns_zone_name)
  dns_name    = format("%s.cloud.", local.de_dns_zone_name)
  description = format("%s DNS zone", local.de_dns_domain)
}

data "kubernetes_service" "ext_ingress_nginx" {
  metadata {
    name      = "ext-ingress-nginx-controller"
    namespace = kubernetes_namespace.ext_ingress_nginx.metadata[0].name
  }
}

resource "google_dns_record_set" "a_records_leonschmidt_cloud" {
  count = length(local.ext_entrys)
  name  = format("%s.%s", local.ext_entrys[count.index][keys(local.ext_entrys[count.index])[0]], google_dns_managed_zone.leonschmidt_cloud.dns_name)
  type  = "A"
  ttl   = 300

  managed_zone = google_dns_managed_zone.leonschmidt_cloud.name

  rrdatas = [data.kubernetes_service.ext_ingress_nginx.status[0].load_balancer[0].ingress[0].ip]
}

#hochzeitsautoschwerin
resource "google_dns_record_set" "a_record_hochzeitsautoschwerin" {
  name = format("%s.", local.de_dns_domain)
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.hochzeitsautoschwerin.name

  rrdatas = [data.kubernetes_service.ext_ingress_nginx.status[0].load_balancer[0].ingress[0].ip]
}