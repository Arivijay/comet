output "cluster_name" { value = module.eks.cluster_name }
output "region" { value = var.aws_region }
output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
