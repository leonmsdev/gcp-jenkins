resource "google_service_account" "worker_cluster_sa" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "worker_cluster" {
  name     = "worker-cluster"
  location = var.gcp_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  disk_type = "pd-standard"
  disk_size = 75
}

resource "google_container_node_pool" "worker_spot_nodes" {
  name       = "worker-node-pool"
  location   = var.gcp_zone
  cluster    = google_container_cluster.worker_cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.worker_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}