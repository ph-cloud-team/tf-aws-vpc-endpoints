module "tf_aws_vpc_endpoints" {
  source = "../../"

  vpc_id = "vpc-00000000000000000"

  endpoints = {
    s3 = {
      service           = "s3"
      vpc_endpoint_type = "Gateway"
      route_table_ids   = ["rtb-00000000000000000"]
    }
  }

  tags = {
    Name               = "basic-vpc-endpoints"
    Environment        = "dev"
    Owner              = "platform-team"
    CostCenter         = "shared-services"
    Application        = "basic"
    DataClassification = "internal"
  }
}
