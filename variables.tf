############################################
# Input variables for tf-aws-vpc-endpoints
############################################

variable "vpc_id" {
  description = "VPC ID where endpoints are created."
  type        = string
}

variable "endpoints" {
  description = "Map of VPC endpoints to create. Gateway endpoints require route_table_ids. Interface endpoints require subnet_ids. Interface endpoints use supplied security_group_ids or the module-managed security group."
  type = map(object({
    service             = string
    service_name        = optional(string, null)
    vpc_endpoint_type   = optional(string, "Interface")
    route_table_ids     = optional(list(string), [])
    subnet_ids          = optional(list(string), [])
    security_group_ids  = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    policy_json         = optional(string, null)
    tags                = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for endpoint in values(var.endpoints) :
      contains(["Gateway", "Interface"], endpoint.vpc_endpoint_type)
    ])
    error_message = "Each endpoint vpc_endpoint_type must be Gateway or Interface."
  }

  validation {
    condition = alltrue([
      for endpoint in values(var.endpoints) :
      endpoint.vpc_endpoint_type != "Gateway" || length(endpoint.route_table_ids) > 0
    ])
    error_message = "Gateway endpoints must provide at least one route_table_id."
  }

  validation {
    condition = alltrue([
      for endpoint in values(var.endpoints) :
      endpoint.vpc_endpoint_type != "Interface" || length(endpoint.subnet_ids) > 0
    ])
    error_message = "Interface endpoints must provide at least one subnet_id."
  }

  validation {
    condition = alltrue([
      for endpoint in values(var.endpoints) :
      endpoint.vpc_endpoint_type != "Interface" || var.create_interface_endpoint_security_group || length(endpoint.security_group_ids) > 0
    ])
    error_message = "Interface endpoints must provide at least one security_group_id or enable create_interface_endpoint_security_group."
  }
}

variable "create_interface_endpoint_security_group" {
  description = "Create a security group for Interface VPC endpoints when endpoint-specific security_group_ids are not provided."
  type        = bool
  default     = true
}

variable "interface_endpoint_security_group_name" {
  description = "Optional name for the module-managed Interface endpoint security group."
  type        = string
  default     = null
}

variable "interface_endpoint_ingress_cidr_blocks" {
  description = "CIDR blocks allowed to connect to Interface endpoints on TCP/443 when the module-managed security group is enabled."
  type        = list(string)
  default     = []
}

variable "interface_endpoint_ingress_security_group_ids" {
  description = "Security group IDs allowed to connect to Interface endpoints on TCP/443 when the module-managed security group is enabled."
  type        = list(string)
  default     = []
}

variable "enable_eks_private_endpoint_set" {
  description = "Create the standard private endpoint set commonly required by EKS private workloads and platform automation."
  type        = bool
  default     = false
}

variable "eks_private_endpoint_services" {
  description = "Standard private endpoint services to create when enable_eks_private_endpoint_set is true."
  type        = set(string)
  default = [
    "s3",
    "ecr_api",
    "ecr_dkr",
    "logs",
    "sts",
    "ec2",
    "ssm",
    "ssmmessages",
    "ec2messages",
    "kms",
    "secretsmanager",
    "elasticloadbalancing"
  ]

  validation {
    condition = alltrue([
      for service in var.eks_private_endpoint_services :
      contains([
        "s3",
        "ecr_api",
        "ecr_dkr",
        "logs",
        "sts",
        "ec2",
        "ssm",
        "ssmmessages",
        "ec2messages",
        "kms",
        "secretsmanager",
        "elasticloadbalancing"
      ], service)
    ])
    error_message = "eks_private_endpoint_services contains an unsupported service key."
  }
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the standard Interface endpoint set."
  type        = list(string)
  default     = []
}

variable "private_route_table_ids" {
  description = "Private route table IDs used by the standard Gateway endpoint set."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common enterprise tags to apply to supported AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Name", "Environment", "Owner", "CostCenter", "Application", "DataClassification"] :
      contains(keys(var.tags), key) && trimspace(var.tags[key]) != ""
    ])
    error_message = "tags must include non-empty Name, Environment, Owner, CostCenter, Application, and DataClassification values."
  }
}
