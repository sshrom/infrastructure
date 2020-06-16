resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = var.allowed_ip_ranges
}

resource "google_compute_firewall" "firewall_http" {
  name = "default-allow-http80"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = var.allowed_http_ip_ranges
}