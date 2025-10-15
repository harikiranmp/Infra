output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "s3_state_bucket" {
  value = module.s3_backend.bucket_name
}
