variable "project_id" {
  description = "GCP Project ID"
  type        = string
  
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty."
  }
}

variable "region" {
  description = "GCP Region"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Region must be a valid GCP region format (e.g., us-central1)."
  }
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,39}$", var.cluster_name))
    error_message = "Cluster name must start with a letter, contain only lowercase letters, numbers, and hyphens, and be 1-40 characters."
  }
}

# Node pool configuration
variable "node_count" {
  description = "Initial number of nodes per zone"
  type        = number
  default     = 1
  
  validation {
    condition     = var.node_count >= 1 && var.node_count <= 1000
    error_message = "Node count must be between 1 and 1000."
  }
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
  
  validation {
    condition     = var.min_node_count >= 0
    error_message = "Minimum node count must be at least 0."
  }
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 10
  
  validation {
    condition     = var.max_node_count >= 1
    error_message = "Maximum node count must be at least 1."
  }
}

variable "machine_type" {
  description = "GCE machine type for nodes"
  type        = string
  default     = "n1-standard-4"
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+$", var.machine_type))
    error_message = "Machine type must be a valid GCE machine type."
  }
}

variable "disk_size_gb" {
  description = "Disk size in GB for each node"
  type        = number
  default     = 100
  
  validation {
    condition     = var.disk_size_gb >= 10 && var.disk_size_gb <= 65536
    error_message = "Disk size must be between 10 and 65536 GB."
  }
}

variable "disk_type" {
  description = "Disk type (pd-standard or pd-ssd)"
  type        = string
  default     = "pd-standard"
  
  validation {
    condition     = contains(["pd-standard", "pd-ssd", "pd-balanced"], var.disk_type)
    error_message = "Disk type must be pd-standard, pd-ssd, or pd-balanced."
  }
}

# GPU configuration
variable "enable_gpu" {
  description = "Enable GPU support"
  type        = bool
  default     = false
}

variable "gpu_type" {
  description = "Type of GPU"
  type        = string
  default     = "nvidia-tesla-t4"
  
  validation {
    condition = contains([
      "nvidia-tesla-t4",
      "nvidia-tesla-p4",
      "nvidia-tesla-p100",
      "nvidia-tesla-v100",
      "nvidia-tesla-a100"
    ], var.gpu_type)
    error_message = "GPU type must be a valid NVIDIA GPU type."
  }
}

variable "gpu_count" {
  description = "Number of GPUs per node"
  type        = number
  default     = 1
  
  validation {
    condition     = var.gpu_count >= 0 && var.gpu_count <= 8
    error_message = "GPU count must be between 0 and 8."
  }
}

# Network configuration
variable "network" {
  description = "VPC network name"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "VPC subnetwork name"
  type        = string
  default     = "default"
}

# Security configuration
variable "enable_shielded_nodes" {
  description = "Enable shielded nodes for enhanced security"
  type        = bool
  default     = true
}

variable "enable_binary_authorization" {
  description = "Enable binary authorization"
  type        = bool
  default     = false
}

variable "enable_network_policy" {
  description = "Enable network policy enforcement"
  type        = bool
  default     = true
}

# Private cluster configuration
variable "enable_private_nodes" {
  description = "Enable private IP addresses for nodes"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private cluster endpoint"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for master endpoint"
  type        = string
  default     = "172.16.0.0/28"
  
  validation {
    condition     = can(cidrhost(var.master_ipv4_cidr_block, 0))
    error_message = "Master CIDR block must be a valid CIDR notation."
  }
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks that can access the master endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

# Maintenance configuration
variable "maintenance_start_time" {
  description = "Start time for daily maintenance window (HH:MM format)"
  type        = string
  default     = "03:00"
  
  validation {
    condition     = can(regex("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", var.maintenance_start_time))
    error_message = "Maintenance start time must be in HH:MM format (00:00 to 23:59)."
  }
}

variable "release_channel" {
  description = "Release channel for GKE cluster (RAPID, REGULAR, STABLE, UNSPECIFIED)"
  type        = string
  default     = "REGULAR"
  
  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE", "UNSPECIFIED"], var.release_channel)
    error_message = "Release channel must be RAPID, REGULAR, STABLE, or UNSPECIFIED."
  }
}

# Labels
variable "labels" {
  description = "Labels to apply to the cluster"
  type        = map(string)
  default     = {}
  
  validation {
    condition = alltrue([
      for k, v in var.labels : can(regex("^[a-z0-9_-]{1,63}$", k)) && can(regex("^[a-z0-9_-]{0,63}$", v))
    ])
    error_message = "Labels must follow GCP labeling constraints."
  }
}

# Node taints
variable "node_taints" {
  description = "Taints to apply to nodes"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

# Additional node metadata
variable "node_metadata" {
  description = "Additional metadata for nodes"
  type        = map(string)
  default = {
    disable-legacy-endpoints = "true"
  }
}

# Preemptible nodes
variable "preemptible" {
  description = "Use preemptible nodes (not recommended for production)"
  type        = bool
  default     = false
}

# Spot nodes
variable "spot" {
  description = "Use spot VMs (newer version of preemptible)"
  type        = bool
  default     = false
}