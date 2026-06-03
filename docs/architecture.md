# Architecture

This module creates Gateway and Interface VPC endpoints for private AWS service access.

## Resource Model

- `aws_vpc_endpoint.this` creates Gateway and Interface endpoints.
- `aws_security_group.interface_endpoint` optionally creates a shared security group for Interface endpoint ENIs.
- `aws_vpc_security_group_ingress_rule.interface_endpoint_https` allows HTTPS from approved CIDR blocks.
- `aws_vpc_security_group_ingress_rule.interface_endpoint_https_source_sg` allows HTTPS from approved source security groups.

## EKS Preset

The EKS private endpoint preset creates common endpoints needed by private workloads:

- S3 Gateway endpoint for object access and Ansible SSM transfer patterns.
- ECR API and ECR Docker endpoints for image pulls.
- CloudWatch Logs endpoint for platform and control-plane logs.
- STS endpoint for IRSA and AWS SDK calls.
- SSM, SSM Messages, and EC2 Messages endpoints for private automation.
- KMS and Secrets Manager endpoints for encrypted configuration access.

Live stacks can still override or add individual endpoint definitions through `endpoints`.
