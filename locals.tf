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

  endpoints = {
    for name, endpoint in var.endpoints : name => merge(endpoint, {
      service_name = coalesce(
        endpoint.service_name,
        "com.amazonaws.${data.aws_region.current.name}.${endpoint.service}"
      )
    })
  }

  interface_endpoint_security_group_enabled = var.create_interface_endpoint_security_group && anytrue([
    for endpoint in values(var.endpoints) : endpoint.vpc_endpoint_type == "Interface"
  ])
}
