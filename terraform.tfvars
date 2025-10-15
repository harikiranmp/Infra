# ----- AWS -----
aws_region = "ap-south-1"

# ----- S3 Backend -----
s3_bucket_name = "hari-tfstate-2025"

# ----- VPC -----
vpc_cidr        = "10.0.0.0/16"
azs             = ["ap-south-1a", "ap-south-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

# ----- EKS -----
cluster_name       = "test-eks"
kubernetes_version = "1.33"

node_instance_type = "t3.small"
node_desired       = 2
node_min           = 2
node_max           = 2

# ----- Common Tags -----
common_tags = {
  Environment = "test-env"
  ManagedBy   = "Terraform"
  Owner       = "HariKiran"
}
