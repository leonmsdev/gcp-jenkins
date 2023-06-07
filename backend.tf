resource "random_pet" "bucket_suffix" {
  length = 1
}

resource "google_storage_bucket" "tf_bucket" {
  project       = var.gcp_project_id
  name          = "jenkins-tfstate-${random_pet.bucket_suffix.id}"
  location      = var.gcp_region
  force_destroy = true
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}