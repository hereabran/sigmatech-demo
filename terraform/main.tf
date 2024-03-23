# Create a tls private and public key for ansible user
# RSA key of size 4096 bits
resource "tls_private_key" "ansible-user-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a VPC Network
resource "google_compute_network" "sigmatech-demo" {
  project                 = var.gcp_project_id
  name                    = "vpc-${var.prefix}"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

# Create a Subnet for respective VPC network
resource "google_compute_subnetwork" "sigmatech-demo" {
  name          = "${var.prefix}-subnetwork"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.sigmatech-demo.id
}

# Create an instance service account
resource "google_service_account" "sigmatech-demo" {
  account_id   = "${var.prefix}-vm"
  display_name = "Custom SA for VM Instance - Sigmatech Webinar Demo"
}

# Create a Google Compute Instance
resource "google_compute_instance" "sigmatech-demo" {
  name         = "${var.prefix}-instance"
  machine_type = "e2-medium"
  zone         = var.gcp_zone

  tags = [var.prefix, "demo", "terraform"]

  boot_disk {
    initialize_params {
      image = var.image_name
      labels = {
        builder = "packer"
      }
    }
  }

  network_interface {
    network    = google_compute_network.sigmatech-demo.name
    subnetwork = google_compute_subnetwork.sigmatech-demo.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    managed_by = "terraform"
    service    = var.prefix
    ssh-keys   = "${var.ansible_user}:${tls_private_key.ansible-user-key.public_key_openssh}"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.sigmatech-demo.email
    scopes = ["cloud-platform"]
  }
}

# Get local public IP
data "http" "local-public-ip" {
  url = var.ip-public-checker-url
}

# Add firewall rule to allow port 22 (SSH) 8000 (Web) and ICMP from certain IP
resource "google_compute_firewall" "sigmatech-demo" {
  name      = "${var.prefix}-firewall"
  network   = google_compute_network.sigmatech-demo.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    data.http.local-public-ip.response_body
  ]

  target_tags = [
    var.prefix, "demo"
  ]
}