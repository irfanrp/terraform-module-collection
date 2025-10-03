# Terraform Module Collection

Well-documented, reusable Terraform modules for common infra patterns (AWS + helpers).

This repo provides composable building blocks (VPC, EC2, S3, IAM, Cloudflare helpers, etc.) with sensible defaults and production-ready options.

## Layout

Top-level folders:

- `modules/` — reusable terraform modules (one folder per module)
- `examples/` — opinionated example usages that demonstrate recommended composition
- `.github/` — CI workflows

See module READMEs for detailed inputs/outputs: `modules/<name>/README.md`.

## Modules (short)

- `vpc`  — VPC, subnets, route tables, NAT (ready)
- `ec2`  — EC2 instances (SSM, user-data, optional public IP) (ready)
- `s3`   — Multi-bucket S3 with encryption, lifecycle, and policies (ready)
- `iam`  — IAM helpers: roles, policies, users (moduleized)
- `cloudflare` — DNS & Tunnel wrapper (examples included)

## Quick start

Try an example locally (uses your cloud creds):

```bash
git clone <repo-url>
cd Terraform-Module-Collection/examples/vpc-basic
terraform init
terraform apply
```

Want a quick syntax/style check across examples?

```bash
make quick-test   # runs fmt + validate across examples
```

## Examples (high level)

- `examples/vpc-basic`
- `examples/ec2-basic`
- `examples/s3-basic`
- `examples/cloudflare-wrapper` (DNS + Tunnel example)

## CI / checks

The CI workflow runs:

- `terraform fmt` and `terraform validate`
- `tflint`, `tfsec`, and `checkov`

CI uploads scan artifacts to PRs for review.

## Recommended tools

- Terraform >= 1.0
- `tflint`, `tfsec` (optional locally; CI runs them)
- `jq` for JSON processing

## Development workflow

1. Create a branch: `git checkout -b feature/xxx`
2. Implement changes in `modules/<mod>` and update `examples/`
3. Run `make quick-test` and `terraform validate` in the example you changed
4. Open a PR; CI will run the checks

## Contributing

Contributions welcome. Open an issue or PR and include example updates or docs for new behavior.

## License

MIT — see `LICENSE`.