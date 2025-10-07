output "cluster_name" { value = google_container_cluster.cluster.name }
output "region" { value = var.region }
output "kubeconfig_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --region ${var.region} --project ${var.project_id}"
}
