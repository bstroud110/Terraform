gcp_service_list = [
  "sqladmin.googleapis.com",             # Cloud SQL Admin API, required by SQL Proxy
  "redis.googleapis.com",                # One Cloud Memorystore (Redis) per cluster
  "servicenetworking.googleapis.com",    # VPC peer network for Cloud SQL
  "networkmanagement.googleapis.com",    # For VPN testing. Can be disabled afterword.
  "artifactregistry.googleapis.com",     # For storing artifacts
  "cloudresourcemanager.googleapis.com", # Cloud Resource Manager. Required for ICS Setup CRE-35123
  "cloudasset.googleapis.com",           # Cloud Resource Manager. Required for ICS Setup CRE-35123
  "policyanalyzer.googleapis.com",       # Cloud Resource Manager. Required for ICS Setup CRE-35123
  "serviceusage.googleapis.com",         # Cloud Resource Manager. Required for ICS Setup CRE-35123
]