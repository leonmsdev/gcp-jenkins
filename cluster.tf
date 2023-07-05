resource "google_container_cluster" "worker_cluster" {
  provider                 = google-beta
  name                     = "worker-cluster"
  location                 = "europe-west4-b"
  remove_default_node_pool = true

  initial_node_count = 1
  network            = google_compute_network.main.self_link
  subnetwork         = google_compute_subnetwork.private.self_link

  networking_mode = "VPC_NATIVE"

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = format("%s.svc.id.goog", var.gcp_project_id)
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  # JENKINS use case
  # master_authorized_networks_config {
  #   cidir_blocks {
  #     cidir_block = "10.0.0.0/18"
  #     display_name = "private-subnet-with-jenkins"
  #   }
  # }
}