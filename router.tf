resource "google_compute_router" "router" {
  name    = "router"
  region  = "europe-west4"
  network = google_compute_network.main.id
}