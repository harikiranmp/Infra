variable "vpc_id" {
  description = "ID of the VPC where bastion will be launched"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for bastion placement"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "Existing IAM instance profile name for bastion"
  type        = string
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
