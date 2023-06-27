locals {
  dns_name = "leonschmidt-cloud"
}

resource "google_dns_managed_zone" "leonschmidt_cloud" {
  name        = local.dns_name
  dns_name    = format("%s.com.", local.dns_name)
  description = "leonschmidt-cloud DNS zone"

  labels = {
    scope = "kubernetes"
  }
}