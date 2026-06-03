############################################
# Local values for tf-aws-vpc-endpoints
############################################

locals {
  module_name = "tf-aws-vpc-endpoints"

  common_tags = merge(
    var.tags,
    {
      ManagedBy = "terraform"
      Module    = local.module_name
    }
  )

  eks_private_endpoint_definitions = {
    s3 = {
      service           = "s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = var.private_route_table_ids
      tags = {
        Name = "${var.tags["Name"]}-s3-endpoint"
      }
    }
    ecr_api = {
      service           = "ecr.api"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ecr-api-endpoint"
      }
    }
    ecr_dkr = {
      service           = "ecr.dkr"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ecr-dkr-endpoint"
      }
    }
    logs = {
      service           = "logs"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-logs-endpoint"
      }
    }
    sts = {
      service           = "sts"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-sts-endpoint"
      }
    }
    ec2 = {
      service           = "ec2"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ec2-endpoint"
      }
    }
    ssm = {
      service           = "ssm"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ssm-endpoint"
      }
    }
    ssmmessages = {
      service           = "ssmmessages"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ssmmessages-endpoint"
      }
    }
    ec2messages = {
      service           = "ec2messages"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-ec2messages-endpoint"
      }
    }
    kms = {
      service           = "kms"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-kms-endpoint"
      }
    }
    secretsmanager = {
      service           = "secretsmanager"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-secretsmanager-endpoint"
      }
    }
    elasticloadbalancing = {
      service           = "elasticloadbalancing"
      vpc_endpoint_type = "Interface"
      subnet_ids        = var.private_subnet_ids
      tags = {
        Name = "${var.tags["Name"]}-elasticloadbalancing-endpoint"
      }
    }
  }

  enabled_eks_private_endpoints = {
    for key, endpoint in local.eks_private_endpoint_definitions : key => endpoint
    if var.enable_eks_private_endpoint_set && contains(var.eks_private_endpoint_services, key)
  }

  endpoints = {
    for name, endpoint in merge(local.enabled_eks_private_endpoints, var.endpoints) : name => merge({
      service_name        = null
      vpc_endpoint_type   = "Interface"
      route_table_ids     = []
      subnet_ids          = []
      security_group_ids  = []
      private_dns_enabled = true
      policy_json         = null
      tags                = {}
      }, endpoint, {
      service_name = coalesce(
        try(endpoint.service_name, null),
        "com.amazonaws.${data.aws_region.current.name}.${endpoint.service}"
      )
    })
  }

  interface_endpoint_security_group_enabled = var.create_interface_endpoint_security_group && anytrue([
    for endpoint in values(local.endpoints) : endpoint.vpc_endpoint_type == "Interface"
  ])
}
