module "tf_aws_vpc_endpoints" {
  source = "../../"

  vpc_id = "vpc-00000000000000000"

  create_interface_endpoint_security_group = true
  interface_endpoint_ingress_cidr_blocks   = ["10.0.0.0/16"]
  private_subnet_ids                       = ["subnet-00000000000000000", "subnet-11111111111111111"]
  private_route_table_ids                  = ["rtb-00000000000000000", "rtb-11111111111111111"]
  enable_eks_private_endpoint_set          = true

  eks_private_endpoint_services = [
    "s3",
    "ecr_api",
    "ecr_dkr",
    "logs",
    "sts",
    "ssm",
    "ssmmessages",
    "ec2messages",
    "kms",
    "secretsmanager"
  ]

  endpoints = {
    elasticloadbalancing = {
      service             = "elasticloadbalancing"
      vpc_endpoint_type   = "Interface"
      subnet_ids          = ["subnet-00000000000000000"]
      private_dns_enabled = true
      tags = {
        Name = "complete-elasticloadbalancing-interface-endpoint"
      }
    }
  }

  tags = {
    Name               = "complete-vpc-endpoints"
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    Application        = "complete"
    DataClassification = "internal"
  }
}
