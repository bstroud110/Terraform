variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "gcp_service_list" {
  description = "APIs that need to be enabled for the project."
  type = list(string)
  default = [
    "container.googleapis.com",             #Need it
    "run.googleapis.com",                   #Need it
    "artifactregistry.googleapis.com",      #Need it
    "cloudbuild.googleapis.com",            #Need it
    "sourcerepo.googleapis.com",            #Need it
    "datastore.googleapis.com",             #Need it
  ]
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "acg_vpc_network" {
  name = "acg-network"
}

resource "google_compute_subnetwork" "acg-public-subnetwork" {
  name          = "acg-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.acg_vpc_network.name
}


#Need to enable GKE services before creating the cluster
resource "google_project_service" "gcp_service_list" {
  for_each = toset(var.gcp_service_list)
  project = var.project_id
  service = each.key
}

#Source:  https://binx.io/2018/11/19/how-to-configure-global-load-balancing-with-google-cloud-platform/
#Reserve an external IP
resource "google_compute_global_address" "paas-monitor" {
  name = "paas-monitor"
}

#Global forwarding rule
resource "google_compute_global_forwarding_rule" "paas-monitor" {
  name       = "paas-monitor-port-80"
  ip_address = "${google_compute_global_address.paas-monitor.address}"
  port_range = "80"
  target     = "${google_compute_target_http_proxy.paas-monitor.self_link}"
}

#Target proxy
resource "google_compute_target_http_proxy" "paas-monitor" {
  name    = "paas-monitor"
  url_map = "${google_compute_url_map.paas-monitor.self_link}"
}

#URL map - but cut down to only us-central1 - due to limitations with ACG playground
resource "google_compute_url_map" "paas-monitor" {
  name        = "paas-monitor"
  default_service = "${google_compute_backend_service.paas-monitor.self_link}"
}

#The backend service
resource "google_compute_backend_service" "paas-monitor" {
  name             = "paas-monitor-backend"
  protocol         = "HTTP"
  port_name        = "paas-monitor"
  timeout_sec      = 10
  session_affinity = "NONE"

  #backend {
  #  group = "${module.instance-group-us-central1.instance_group_manager}"
  #}

  #health_checks = ["${module.instance-group-us-central1.health_check}"]
}

#Health checks
resource "google_compute_http_health_check" "paas-monitor" {
  name         = "paas-monitor-${var.region}"
  request_path = "/health"

  timeout_sec        = 5
  check_interval_sec = 5
  port               = 1337

  lifecycle {
    create_before_destroy = true
  }
}

#Open port necessary for gcp to probe health check
resource "google_compute_firewall" "paas-monitor" {
  ## firewall rules enabling the load balancer health checks
  name    = "paas-monitor-firewall"
  network = "default"

  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1337"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["paas-monitor"]
}


