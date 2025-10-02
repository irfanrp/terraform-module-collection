# Terraform Module Collection

**Acurated collection of reusable Terraform modules for AWS infrastructure**

## 📁 Structure

```
terraform-modules/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── eks/
│   ├── rds/
│   ├── s3/
│   └── iam/
├── examples/
│   ├── vpc-basic/
│   ├── eks-basic/
│   └── ...
└── README.md
```

## Available Modules

| Module | Description | Status |
|--------|-------------|--------|
| [VPC](./modules/vpc/) | Virtual Private Cloud with subnets | ✅ Ready |
| [EKS](./modules/eks/) | Elastic Kubernetes Service | 🚧 In Progress |
| [RDS](./modules/rds/) | Relational Database Service | 📋 Planned |
| [S3](./modules/s3/) | Simple Storage Service | 📋 Planned |
| [IAM](./modules/iam/) | Identity and Access Management | 📋 Planned |
| [EC2](./modules/ec2/) | Elastic Compute Cloud Instances | ✅ Ready |

## Quick Start

### Using VPC Module

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  name               = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b"]
  
  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

### Using Examples

Additional example directories:
- `examples/ec2-basic` (launch EC2 instances using VPC module)

**Real AWS (needs credentials):**
```bash
cd examples/vpc-basic
terraform init
terraform plan
terraform apply
```

**Local Testing (no credentials needed):**
```bash
# Quick syntax check
make quick-test

# OR manually
cd examples/vpc-syntax-check
terraform init
terraform validate
```

**LocalStack Testing (local AWS simulation):**
```bash
# Start LocalStack first
localstack start

# Then test
make test-localstack
```

## 📋 Requirements

**For Real AWS:**
- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS CLI configured

**For Local Testing:**
- Terraform >= 1.0 (only)
- Optional: LocalStack for simulation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Add tests for your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.