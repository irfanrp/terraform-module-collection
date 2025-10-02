# Terraform Module Collection

Reusable, well-documented Terraform modules for common AWS infrastructure patterns.

Targets small teams and platform engineers who want composable building blocks (VPC, EC2, S3, IAM, etc.) with sensible defaults and production-ready options.

--------------------------------------------------------------------------------

## Repository layout

```
.
├── .github/                 # CI workflows
├── examples/                # Opinionated example usages for modules
├── modules/                 # Reusable terraform modules
│   ├── ec2/
│   ├── vpc/
│   ├── s3/
│   └── ...
├── Makefile                 # helpers (format, quick-test)
├── README.md                # this file
└── LICENSE
```

## Modules (summary)

| Module | Purpose | Status |
|--------|---------|:-----:|
| `vpc`  | VPC, subnets, route tables, NAT | ✅ Ready |
| `ec2`  | EC2 instances (SSM, CloudWatch, user-data) | ✅ Ready |
| `s3`   | S3 buckets: multi-bucket support, encryption, lifecycle, policies | ✅ Ready |
| `eks`  | EKS cluster (work in progress) | 🚧 In Progress |
| `rds`  | RDS databases (planned) | 📋 Planned |
| `iam`  | Reusable IAM role/policy helpers | 📋 Planned |

See module READMEs for full input/output details (`modules/<name>/README.md`).

## Quick start

Clone the repo and try an example (this will use your AWS credentials):

```bash
git clone <repo-url>
cd Terraform-Module-Collection/examples/vpc-basic
terraform init
terraform apply
```

For a quick local syntax check without touching AWS:

```bash
make quick-test   # runs fmt + validate across examples
```

## Examples

- `examples/vpc-basic` — minimal VPC
- `examples/ec2-basic` — EC2 instances using the VPC module
- `examples/s3-basic` — S3 example using the new multi-bucket S3 module
- `examples/ec2-advanced` — advanced EC2 pattern (bastion, placement groups, monitoring)

## CI / Checks

The repository includes a GitHub Actions workflow (`.github/workflows/ci.yml`) which runs:

- `terraform fmt` / `terraform validate` (quick-test)
- `tfsec` (terraform security scanner)
- `tflint` (Terraform linter)
- `checkov` (policy-as-code checks)

Artifacts (tfsec/tflint/checkov outputs) are uploaded for PR review.

## Recommended local tools

- Terraform >= 1.0
- `tfsec`, `tflint` (optional: CI already runs them)
- `jq` (for JSON policy checks)
- `localstack` (if you want to run examples locally against a simulated AWS)

## Development workflow

1. Create a feature branch: `git checkout -b feature/xxxx`
2. Implement module changes in `modules/<module>` and add/update examples in `examples/`
3. Run `make quick-test` and `terraform validate` in examples
4. Push branch and open a PR

CI will run the linters and security checks automatically.

## Roadmap ideas

- Cross-region replication and DR for S3
- Test harness (terratest) for end-to-end validation
- Publish modules to the Terraform Registry

## Contributing

Contributions welcome — please open an issue or PR. Follow the standard GitHub PR flow and include changes to examples and docs when adding features.

## License

MIT — see the `LICENSE` file for details.