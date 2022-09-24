resource "google_project_service" "gcp_services" {
  count   = length(var.gcp_api_service_list)
  project = var.project_name
  service = var.gcp_service_list[count.index]

  disable_dependent_services = true
}

