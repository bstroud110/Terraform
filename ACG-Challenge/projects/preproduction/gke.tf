#Terraform declaration file for Kubernetes

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "Number of GKE nodes."
}

#GKE Cluster details
resource "google_container_cluster" "acg_cluster" {
  name                     = "acg-cluster"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.acg_vpc_network.name
  subnetwork               = google_compute_subnetwork.acg-public-subnetwork.name
}

#Separately managed node pool
resource "google_container_node_pool" "primary_nodes" {
  #depends_on = [google_project_service.gcp.services]  
  name       = "acg-node-pool"
  location   = var.region
  cluster    = google_container_cluster.acg_cluster.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "f1-micro"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}