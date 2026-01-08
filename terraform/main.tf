# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "inception-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "inception-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Firewall (Allow SSH, HTTP, HTTPS, FTP)
resource "google_compute_firewall" "allow_access" {
  name    = "inception-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    # 22(SSH), 80/443(Web), 21(FTP Control), 21100-21110(FTP Passive)
    ports = ["22", "80", "443", "21", "21100-21110"]
  }

  # 全世界からのアクセスを許可 (実運用では制限すべきだが課題要件としてPublic Accessが必要)
  source_ranges = ["0.0.0.0/0"]
}

# Static IP
resource "google_compute_address" "static_ip" {
  name   = "inception-static-ip"
  region = var.region
}

# Persistent Disk
resource "google_compute_disk" "data_disk" {
  name = "inception-compute-disk"
  type = "pd-standard"
  zone = var.zone
  size = 10
}

# VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = "inception-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      # Ubuntu 20.04 LTS
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 20
    }
  }

  attached_disk {
    source      = google_compute_disk.data_disk.id
    device_name = "inception_data"
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }

  tags = ["http-server", "https-server", "inception-server"]

  # for Ansible
  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y python3"
}

# Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    ip_address = google_compute_address.static_ip.address
    ssh_user   = var.ssh_user
    ssh_key    = var.ssh_pub_key_path
  })
  filename = "../ansible/inventory.ini"
}