resource "local_sensitive_file" "ansible-user-priv-key" {
  content         = tls_private_key.ansible-user-key.private_key_pem
  filename        = "${path.module}/.terraform/${var.ansible_user}.pem"
  file_permission = "0600"
}

output "ansible-user-public-key" {
  value     = try(tls_private_key.ansible-user-key.public_key_openssh, "")
  sensitive = true
}

output "local-public-ip" {
  value = try(data.http.local-public-ip.response_body, "")
}

output "external-ip-address" {
  value = try(google_compute_instance.sigmatech-demo.network_interface[0].access_config[0].nat_ip, "")
}