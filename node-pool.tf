resource "google_container_node_pool" "main_workload" {
  name       = "main-workload"
  cluster    = google_container_cluster.worker_cluster.id
  node_count = 1

  depends_on = [google_container_cluster.worker_cluster]

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-2"
    disk_size_gb = 50
    disk_type    = "pd-standard"

    service_account = "766712485593-compute@developer.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}