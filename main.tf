############################################
# Main resources for tf-aws-vpc-endpoints
############################################

resource "aws_security_group" "interface_endpoint" {
  count = local.interface_endpoint_security_group_enabled ? 1 : 0

  name        = coalesce(var.interface_endpoint_security_group_name, "${var.tags["Name"]}-interface-endpoints")
  description = "Security group for Interface VPC endpoints managed by ${local.module_name}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name         = coalesce(var.interface_endpoint_security_group_name, "${var.tags["Name"]}-interface-endpoints")
      ResourceRole = "interface-endpoint-security-group"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "interface_endpoint_https" {
  for_each = local.interface_endpoint_security_group_enabled ? toset(var.interface_endpoint_ingress_cidr_blocks) : toset([])

  security_group_id = aws_security_group.interface_endpoint[0].id
  cidr_ipv4         = each.value
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Allow HTTPS to Interface VPC endpoints"
}

resource "aws_vpc_endpoint" "this" {
  for_each = local.endpoints

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  route_table_ids   = each.value.vpc_endpoint_type == "Gateway" ? each.value.route_table_ids : null
  subnet_ids        = each.value.vpc_endpoint_type == "Interface" ? each.value.subnet_ids : null
  security_group_ids = each.value.vpc_endpoint_type == "Interface" ? (
    length(each.value.security_group_ids) > 0 ? each.value.security_group_ids : [aws_security_group.interface_endpoint[0].id]
  ) : null
  private_dns_enabled = each.value.vpc_endpoint_type == "Interface" ? each.value.private_dns_enabled : null
  policy              = each.value.policy_json

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = coalesce(
        lookup(each.value.tags, "Name", null),
        "${var.tags["Name"]}-${each.key}-endpoint"
      )
      EndpointType = each.value.vpc_endpoint_type
      Service      = each.value.service
    }
  )
}
