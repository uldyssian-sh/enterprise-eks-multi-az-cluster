variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security group ID for the cluster"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  type        = string
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks for public access"
  type        = list(string)
  validation {
    condition     = length(var.public_access_cidrs) > 0
    error_message = "At least one CIDR block must be specified for public access."
  }
}

variable "node_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 3
}

variable "node_max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 6
}

variable "node_min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
  validation {
    condition     = var.node_min_size >= 0 && var.node_min_size <= var.node_desired_size && var.node_desired_size <= var.node_max_size
    error_message = "Node scaling must satisfy: 0 <= min_size <= desired_size <= max_size."
  }
}

variable "node_disk_size" {
  description = "Disk size for nodes in GB"
  type        = number
  default     = 20
}

variable "node_ami_type" {
  description = "AMI type for the node group"
  type        = string
  default     = "AL2_x86_64"
  validation {
    condition     = contains(["AL2_x86_64", "AL2_x86_64_GPU", "AL2_ARM_64", "CUSTOM", "BOTTLEROCKET_ARM_64", "BOTTLEROCKET_x86_64"], var.node_ami_type)
    error_message = "AMI type must be one of: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM, BOTTLEROCKET_ARM_64, BOTTLEROCKET_x86_64."
  }
}

variable "node_capacity_type" {
  description = "Capacity type for the node group"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "Capacity type must be either ON_DEMAND or SPOT."
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}