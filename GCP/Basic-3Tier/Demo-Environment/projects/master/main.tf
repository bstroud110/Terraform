provider "google" {
  credentials = file("keys/terraform-sa-instance.json")
  project = "playground-s-11-814f9d64"
  region  = "us-central1"
  zone    = "us-central1-c"
}

module "network-services" {
  # Network resources - not yet in service
  source = "../../modules/network"
  gcp_network = var.gcp_network
  project_name = var.project
}

resource "google_compute_network" "demo_vpc_network" {
  name = "demo-network"
}

resource "google_compute_subnetwork" "demo-public-subnetwork" {
  name          = "demo-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.demo_vpc_network.name
  }

resource "google_compute_instance" "demo_instance" {
  name         = "demo-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "demo-network"
    access_config {
    }
  }
}