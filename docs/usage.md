# Usage

This document describes how to consume the tf-aws-vpc-endpoints Terraform module from live Terraform repositories.

## S3 Gateway Endpoint

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

## Interface Endpoint

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
