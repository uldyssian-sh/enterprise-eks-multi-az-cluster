output "cluster_id" {
  description = "EKS cluster ID"
  value       = try(aws_eks_cluster.main.id, null)
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = try(aws_eks_cluster.main.arn, null)
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = try(aws_eks_cluster.main.endpoint, null)
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = try(aws_eks_cluster.main.vpc_config[0].cluster_security_group_id, null)
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(aws_eks_cluster.main.certificate_authority[0].data, null)
}

output "node_group_role_arn" {
  description = "IAM role ARN for EKS node groups"
  value       = try(aws_iam_role.node_group.arn, null)
}



output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = try(aws_eks_cluster.main.version, null)
}