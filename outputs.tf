############################################
# Outputs for tf-aws-vpc-endpoints
############################################

output "module_name" {
  description = "Name of the Terraform module."
  value       = local.module_name
}

output "endpoint_ids" {
  description = "Map of endpoint keys to VPC endpoint IDs."
  value = {
    for key, endpoint in aws_vpc_endpoint.this : key => endpoint.id
  }
}

output "endpoint_arns" {
  description = "Map of endpoint keys to VPC endpoint ARNs."
  value = {
    for key, endpoint in aws_vpc_endpoint.this : key => endpoint.arn
  }
}

output "service_names" {
  description = "Map of endpoint keys to resolved AWS service names."
  value = {
    for key, endpoint in aws_vpc_endpoint.this : key => endpoint.service_name
  }
}

output "dns_entries" {
  description = "Map of endpoint keys to DNS entries. Gateway endpoints return an empty list."
  value = {
    for key, endpoint in aws_vpc_endpoint.this : key => endpoint.dns_entry
  }
}

output "route_table_ids" {
  description = "Map of endpoint keys to associated route table IDs."
  value = {
    for key, endpoint in aws_vpc_endpoint.this : key => endpoint.route_table_ids
  }
}

output "interface_endpoint_security_group_id" {
  description = "Module-managed Interface endpoint security group ID, or null when not created."
  value       = local.interface_endpoint_security_group_enabled ? aws_security_group.interface_endpoint[0].id : null
}
