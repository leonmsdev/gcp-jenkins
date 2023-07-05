resource "google_service_account" "kubernets" {
  account_id = "kubernetes"
}

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
    machine_type = "e2-standard-2"
    disk_size_gb = 50
    disk_type    = "pd-standard"

    service_account = google_service_account.kubernets.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}