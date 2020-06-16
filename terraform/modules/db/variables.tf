variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Name of zone for google_compute_instance"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}