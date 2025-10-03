# IAM module

This module creates an IAM role with optional managed policy attachments and inline policies. It can also create an instance profile for EC2 usage.

Features:
- Create a role (configurable name or prefix)
- Attach managed policy ARNs (list)
- Attach inline policies (map of name -> JSON string)
- Optionally create an instance profile

Inputs (high level):
- `role_name`, `name_prefix`, `assume_role_policy`, `assume_services`, `managed_policy_arns`, `inline_policies`, `create_instance_profile`

Outputs:
- `role_name`, `role_arn`, `instance_profile_name`, `instance_profile_arn`

Example (attach to EC2 module):

```hcl
module "iam_ssm" {
  source = "../../modules/iam"

  name_prefix             = "ec2-ssm-"
  assume_services         = ["ec2.amazonaws.com"]
  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  create_instance_profile = true
}

module "ec2" {
  source = "../../modules/ec2"

  # ...other inputs
  create_ssm_instance_profile = false # if you want to rely on external iam module instead
  iam_instance_profile         = module.iam_ssm.instance_profile_name
}
```

Notes:
- Inline policies should be valid JSON strings. The module does not parse them; it attaches them as provided.
- The module is intentionally small and focused. If you'd like more opinionated behavior (role assume for lambda, ECS, etc.), I can add presets.
# IAM Module

🚧 **Coming Soon** - AWS Identity and Access Management module

## Planned Features

- IAM Roles
- IAM Policies
- IAM Users
- IAM Groups
- Instance Profiles
- Service-linked roles
- Cross-account roles
- OIDC Identity Providers

## Usage (Preview)

```hcl
module "iam" {
  source = "./modules/iam"
  
  # EC2 Instance Role
  create_instance_role = true
  instance_role_name   = "ec2-instance-role"
  instance_role_policies = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  
  # EKS Service Role
  create_eks_role = true
  eks_role_name   = "eks-service-role"
  
  # Lambda Execution Role
  create_lambda_role = true
  lambda_role_name   = "lambda-execution-role"
  lambda_role_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  
  tags = {
    Environment = "dev"
  }
}
```

Stay tuned for updates!