output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Endpoint for the GKE cluster"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded CA certificate for the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pool_name" {
  description = "Name of the default node pool"
  value       = google_container_node_pool.primary_nodes.name
}

output "cluster_id" {
  description = "Cluster ID in the format projects/{project}/locations/{location}/clusters/{cluster}"
  value       = google_container_cluster.primary.id
}

output "cluster_location" {
  description = "Location of the cluster"
  value       = google_container_cluster.primary.location
}

output "cluster_master_version" {
  description = "Master version of the cluster"
  value       = google_container_cluster.primary.master_version
}

output "node_pool_instance_group_urls" {
  description = "List of instance group URLs for the node pool"
  value       = google_container_node_pool.primary_nodes.instance_group_urls
}

output "service_account_email" {
  description = "Email of the service account created for nodes"
  value       = google_service_account.gke_node_sa.email
}

output "workload_identity_config" {
  description = "Workload Identity configuration"
  value = {
    workload_pool = google_container_cluster.primary.workload_identity_config[0].workload_pool
  }
}

output "network" {
  description = "Network used by the cluster"
  value       = google_container_cluster.primary.network
}

output "subnetwork" {
  description = "Subnetwork used by the cluster"
  value       = google_container_cluster.primary.subnetwork
}

output "cluster_ipv4_cidr" {
  description = "CIDR block for the cluster pods"
  value       = google_container_cluster.primary.cluster_ipv4_cidr
}

output "services_ipv4_cidr" {
  description = "CIDR block for the cluster services"
  value       = google_container_cluster.primary.services_ipv4_cidr
}

output "master_authorized_networks_config" {
  description = "Master authorized networks configuration"
  value       = google_container_cluster.primary.master_authorized_networks_config
  sensitive   = true
}

output "private_cluster_config" {
  description = "Private cluster configuration"
  value = {
    enable_private_nodes    = google_container_cluster.primary.private_cluster_config[0].enable_private_nodes
    enable_private_endpoint = google_container_cluster.primary.private_cluster_config[0].enable_private_endpoint
    master_ipv4_cidr_block  = google_container_cluster.primary.private_cluster_config[0].master_ipv4_cidr_block
  }
  sensitive = true
}

output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}