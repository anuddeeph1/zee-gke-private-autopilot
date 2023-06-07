# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  #provider = google-beta
  #project  = zee-ott-private
  name     = "zee-autopilot-private-k8s"
  location = "asia-south1"
  #remove_default_node_pool = true
  #initial_node_count       = 1
  network            = google_compute_network.main.self_link
  subnetwork         = google_compute_subnetwork.private.self_link
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  networking_mode    = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  #node_locations = [
  #  "asia-south1-b"
  #]

  #addons_config {
  #  http_load_balancing {
  #    disabled = true
  #  }
    #horizontal_pod_autoscaling {
    #  disabled = false
    #}
  #}
  enable_autopilot = true
  release_channel {
    channel = "STABLE"
  }

#  workload_identity_config {
#    workload_pool = "zee-ott-private.svc.id.goog"
#  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

