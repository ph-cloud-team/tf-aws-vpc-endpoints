# vpc-endpoints

## 1. Overview
Provides AWS VPC Endpoint resources to enable private connectivity between VPCs and AWS services without traversing the public internet.

This module standardizes VPC Endpoint creation to ensure secure, governed, and consistent private service access across enterprise AWS environments.

---

## 2. Purpose
The vpc-endpoints module enables controlled and centralized configuration of AWS VPC Endpoints (Interface and Gateway types).  
It reduces public internet exposure and enforces enterprise standards for private service connectivity.

This module is a foundational component of the enterprise private-access and zero-trust networking strategy.

---

## 3. Scope & Responsibilities

### This module DOES:
- Create AWS VPC Interface Endpoints
- Create AWS VPC Gateway Endpoints
- Associate endpoints with subnets and route tables as required
- Attach security groups to interface endpoints
- Support standardized enterprise tagging

### This module DOES NOT:
- Create VPCs
- Create subnets
- Manage DNS zones outside endpoint scope
- Control routing beyond endpoint-specific requirements

---

## 4. Provider & Backend Responsibility
This module does not configure providers or Terraform backends.

- Provider configuration is owned by consuming tf-live repositories
- Backend configuration is strictly prohibited in shared modules
- This module is reusable across accounts and regions

---

## 5. Enterprise Tagging Standard

This module enforces organization-wide tagging standards.

### Mandatory Enterprise Tags
The following tags **must be provided** by consuming tf-live repositories:
- org
- application
- environment
- owner
- cost_center
- managed_by
- project
- region
- compliance
- criticality

### Tag Responsibility Model
- tf-live repositories define tag values
- This module validates mandatory tags and propagates them to all resources
- No business context is hardcoded within the module

### Module-Specific Tags
This module may append VPC endpoint–specific tags (for example `resource_role = vpc-endpoint`) without overriding enterprise tags.

---

## 6. Design Principles
- Private-by-default service access
- Least-privilege connectivity
- Explicit endpoint declaration
- Clear separation between service access and routing logic

---

## 7. Usage

### S3 Gateway Endpoint

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/network/tf-aws-vpc-endpoints.git?ref=v1.0.0"

  vpc_id = data.aws_vpc.selected.id

  endpoints = {
    s3 = {
      service           = "s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = [data.aws_route_table.private.id]
    }
  }

  tags = {
    Name               = "dev-workload"
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    Application        = "maas-ec2"
    DataClassification = "internal"
  }
}
```

### Interface Endpoint

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/network/tf-aws-vpc-endpoints.git?ref=v1.0.0"

  vpc_id = data.aws_vpc.selected.id

  endpoints = {
    ssm = {
      service             = "ssm"
      vpc_endpoint_type   = "Interface"
      subnet_ids          = [data.aws_subnet.private.id]
      security_group_ids  = [aws_security_group.endpoint.id]
      private_dns_enabled = true
    }
  }

  tags = {
    Name               = "dev-workload"
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    Application        = "maas-ec2"
    DataClassification = "internal"
  }
}
```

---

## 8. Outputs
- `endpoint_ids`
- `endpoint_arns`
- `service_names`
- `dns_entries`
- `route_table_ids`

---

## 9. Intended Consumers
This module is intended to be consumed by:
- `route-tables` module
- `tf-live-network-*` repositories

Direct consumption by application teams is not supported.

---

## 10. Module Testing Strategy
This module is validated before release using:
- Static validation (`terraform validate`)
- Example harnesses under `examples/`
- Apply and destroy testing in a sandbox AWS account

tf-live repositories consume only tagged, tested versions.

---

## 11. Repository Structure

├── main.tf        # VPC Endpoint resources  
├── variables.tf   # Input contract  
├── outputs.tf     # Exported identifiers  
├── versions.tf    # Provider constraints  
├── examples/  
│   └── minimal/  
└── README.md  

---

## 12. Versioning & Compatibility
Semantic versioning is enforced:

- v1.x.x – Backward-compatible enhancements
- v2.x.x – Breaking changes to endpoint interfaces or outputs

---

## 13. Change & Upgrade Expectations
- Endpoint types and associated services are immutable once created
- Existing outputs will not be removed without a major version bump
- Behavioral changes require explicit release notes

---

## 14. Ownership & Governance
Owned by the Cloud Platform / Networking team.

All changes require architectural review and approval from module owners.
