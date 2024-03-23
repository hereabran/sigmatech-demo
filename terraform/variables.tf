variable "gcp_project_id" {
  default = "heredemo"
}

variable "gcp_region" {
  default = "asia-southeast2"
}

variable "gcp_zone" {
  default = "asia-southeast2-c"
}

variable "prefix" {
  default = "sigmatech-demo"
}

variable "ansible_user" {}

variable "image_name" {}

variable "ip-public-checker-url" {
  default = "https://ifconfig.me/ip"
  #  default = "https://2ip.io"
}