variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region (or set zone and override location below)"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "comet-hello-gke"
}

variable "cluster_version" {
  description = "GKE master version (leave empty for default)"
  type        = string
  default     = ""
}

variable "network_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary range for Pods"
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr" {
  description = "Secondary range for Services"
  type        = string
  default     = "10.30.0.0/20"
}

variable "node_machine_type" {
  description = "Node machine type"
  type        = string
  default     = "e2-standard-2"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}
