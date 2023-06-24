# resource "google_project_service" "compute" {
#   service = "compute.googleapis.com"
# }

# # This api is needed to use kubernetes cluster
# resource "google_project_service" "container" {
#   service = "container.googleapis.com"
# }

resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = "europe-west4"
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  # Is used for the kubernetes pods
  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }

  # Is used for the public ip services inside the cluster
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }

}