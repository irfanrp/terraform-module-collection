# EKS Module

🚧 **Coming Soon** - Amazon Elastic Kubernetes Service module

## Planned Features

- EKS Cluster
- Node Groups
- Fargate Profiles
- OIDC Provider
- Add-ons (VPC CNI, CoreDNS, kube-proxy)
- RBAC Configuration

## Usage (Preview)

```hcl
module "eks" {
  source = "./modules/eks"
  
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.27"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  
  node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
  
  tags = {
    Environment = "dev"
  }
}
```

Stay tuned for updates!