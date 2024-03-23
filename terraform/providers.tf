terraform {
  backend "gcs" {
    bucket = "gamatech-tfstate"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

#provider "google-beta" {}