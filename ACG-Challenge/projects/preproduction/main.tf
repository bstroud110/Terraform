provider "google" {
    project = "playground-s-11-0b122fc5"
    region  = "us-central1"
}

resource "google_compute_network" "acg_vpc_network" {
  name = "acg-network"
}

resource "google_compute_subnetwork" "acg-public-subnetwork" {
  name          = "acg-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.acg_vpc_network.name
  }

#resource "google_service_account" "terraform-sa" {
#  account_id   = "terraform-sa@playground-s-11-0b122fc5.iam.gserviceaccount.com"
#  display_name = "Service Account for Terraform"
#}

#Need to enable GKE services before creating the cluster
module "services" {
    #Trying to set up a list of services
    source = "./modules/project-services"
    gcp_service_list = var.gcp_service_list
}



resource "google_container_cluster" "acg_cluster" {
    name    = "acg-cluster"
    location    = "us-central1-c"
    remove_default_node_pool = true
    initial_node_count  = 1
}

