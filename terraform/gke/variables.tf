variable "project_id" { type = string }
variable "region"     { type = string  default = "us-central1" }
variable "cluster_name" { type = string default = "comet-hello-gke" }
variable "cluster_version" { type = string default = "" }
variable "network_cidr" { type = string default = "10.10.0.0/16" }
variable "subnet_cidr"  { type = string default = "10.10.0.0/20" }
variable "pods_cidr"    { type = string default = "10.20.0.0/16" }
variable "services_cidr" { type = string default = "10.30.0.0/20" }
variable "node_machine_type" { type = string default = "e2-standard-2" }
variable "node_count"   { type = number default = 2 }
