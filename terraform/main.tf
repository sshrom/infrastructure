terraform {
  # Версия terraform
  required_version = "0.12.26"
}

provider "google" {
  # Версия провайдера
  version = "2.5.0"

  # ID проекта
  project = var.project
  region  = var.region
}

# ресурс для описания/создания инстанса VM в GCP
resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone_instance
  tags         = ["reddit-app"]

  # пусть к публичному ключу
  metadata = {
    ssh-keys = "squid:${file(var.public_key_path)}"
  }

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {
    }
  }
  connection {
    # host = self.public_ip
    type  = "ssh"
    user  = "squid"
    host  = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
    agent = false

    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

# добавляем правило фаерволла для приложения
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}
