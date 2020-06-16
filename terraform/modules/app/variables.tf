variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable zone {
  description = "Name of zone for google_compute_instance"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
#  default     = "reddit-full-1592238579"
}
