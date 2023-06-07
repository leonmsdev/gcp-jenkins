variable "gcp_project" {
  type        = string
  description = "Google project id"
  default     = "jenkins-389117"
}

variable "gcp_region" {
  type        = string
  description = "Google project region"
  default     = "europe-west4"
}

variable "gcp_zone" {
  type        = string
  description = "Google project zone"
  default     = "europe-west4-a"
}