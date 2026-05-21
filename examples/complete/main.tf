module "tf_aws_vpc_endpoints" {
  source = "../../"

  vpc_id = "vpc-00000000000000000"

  create_interface_endpoint_security_group = true
  interface_endpoint_ingress_cidr_blocks   = ["10.0.0.0/16"]

  endpoints = {
    s3 = {
      service           = "s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids = [
        "rtb-00000000000000000",
        "rtb-11111111111111111"
      ]
      tags = {
        Name = "complete-s3-gateway-endpoint"
      }
    }

    ssm = {
      service             = "ssm"
      vpc_endpoint_type   = "Interface"
      subnet_ids          = ["subnet-00000000000000000"]
      private_dns_enabled = true
      tags = {
        Name = "complete-ssm-interface-endpoint"
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
