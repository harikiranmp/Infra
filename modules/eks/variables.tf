variable "cluster_name" {
  description = "Name for EKS Cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where EKS should deploy"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "Optional pre-created IAM role ARN for EKS cluster (if not created here)"
  type        = string
  default     = null
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.small"
}

variable "node_desired" {
  description = "Desired node count"
  type        = number
  default     = 1
}

variable "node_min" {
  description = "Minimum node count"
  type        = number
  default     = 1
}

variable "node_max" {
  description = "Maximum node count"
  type        = number
  default     = 2
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
