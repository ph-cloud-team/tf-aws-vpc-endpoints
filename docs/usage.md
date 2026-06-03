# Usage

## EKS Private Workload Baseline

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/network/tf-aws-vpc-endpoints.git?ref=v1.0.0"

  vpc_id = module.vpc.vpc_id

  enable_eks_private_endpoint_set = true
  private_subnet_ids              = module.vpc.private_subnet_ids
  private_route_table_ids         = module.vpc.private_route_table_ids

  interface_endpoint_ingress_cidr_blocks = [
    module.vpc.vpc_cidr_block
  ]

  tags = local.tags
}
```

## Add an Extra Endpoint

```hcl
endpoints = {
  elasticloadbalancing = {
    service           = "elasticloadbalancing"
    vpc_endpoint_type = "Interface"
    subnet_ids        = module.vpc.private_subnet_ids
  }
}
```

Explicit `endpoints` override standard endpoint keys when the same key is used.

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
