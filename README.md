# Terraform Module Collection

Reusable, well-documented Terraform modules for common AWS patterns.

Keep it simple — this repo contains modular building blocks and examples you can compose:

- `modules/` — each module (vpc, ec2, s3, iam, rds, etc.)
- `examples/` — opinionated examples showing how to use modules

Quick start

1. Clone the repo and open an example:

```bash
git clone <repo-url>
cd Terraform-Module-Collection/examples/vpc-basic
terraform init
terraform apply
```

Tests & checks

- Use `make quick-test` to run `terraform fmt` and `terraform validate` across examples.
- CI also runs `tflint`, `tfsec`, and uploads artifacts for review.

Contributing

- Create a branch `feature/xxx`, update modules/examples, run `make quick-test`, and open a PR.

License

MIT — see `LICENSE`.

For details on inputs/outputs and usage, open the `README.md` inside each `modules/<name>/` folder.