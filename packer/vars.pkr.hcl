variable "gcp_project_id" {
  default = ""
}

variable "gcp_region" {
  default = "asia-southeast2"
}

variable "gcp_zone" {
  default = "asia-southeast2-c"
}

variable "ssh_username" {
  default = "packer"
}

variable "source_image_family" {
  default = "ubuntu-2204"
}

variable "source_image" {
  default = "ubuntu-2204-jammy-v20240315a"
}

variable "ansible_user" {
  default = "ansible"
}

variable "image_name" {
  default = "packer-sigmatech-demo"
}