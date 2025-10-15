output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks-cluster.name
}

output "cluster_endpoint" {
  description = "EKS private API endpoint"
  value       = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

output "node_role_arn" {
  description = "IAM role ARN for node group"
  value       = aws_iam_role.eks_node_role.arn
}
