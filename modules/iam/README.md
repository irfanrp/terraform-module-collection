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