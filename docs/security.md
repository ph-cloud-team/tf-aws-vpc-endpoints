# Security

VPC endpoints reduce public internet dependency for AWS API traffic and are a core control for private EKS and EC2 automation.

## Controls

- Interface endpoints use private DNS by default.
- Gateway endpoints require explicit route table IDs.
- Interface endpoints require subnet IDs.
- Interface endpoints require endpoint security groups, either supplied or module-managed.
- Module-managed endpoint security group ingress can be restricted by VPC CIDR or source security group.

## Recommendations

- Prefer source security group ingress for production EKS node groups where practical.
- Use VPC CIDR ingress for simpler lab/dev environments.
- Keep endpoint policies restrictive when service-specific access boundaries are required.
- Do not use VPC endpoints as a substitute for IAM least privilege; they only control network path.
