module "s3_backend" {
  source      = "./modules/s3_backend"
  bucket_name = var.s3_bucket_name
  common_tags = var.common_tags
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  common_tags     = var.common_tags
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  node_desired       = var.node_desired
  node_min           = var.node_min
  node_max           = var.node_max
  common_tags        = var.common_tags
}

module "bastion" {
  source              = "./modules/bastion"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  iam_instance_profile = "bastion-ssm-profile"
  common_tags         = var.common_tags
}

