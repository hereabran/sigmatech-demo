packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "sigmatech-demo" {
  project_id          = var.gcp_project_id
  source_image        = var.source_image
  source_image_family = var.source_image_family
  ssh_username        = var.ssh_username
  zone                = var.gcp_zone
  disk_name           = "packer-sigmatech-demo-disk"

  image_name        = var.image_name
  image_description = "Packer demo image for Sigmatech Webinar"
  image_labels = {
    "builder" = "packer"
  }
}

build {
  sources = ["sources.googlecompute.sigmatech-demo"]

  provisioner "shell" {
    environment_vars = [
      "ANSIBLE_USER=${var.ansible_user}",
    ]
    script = "${path.root}/scripts/bootstrap.sh"
  }
}
