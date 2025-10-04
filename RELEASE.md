# Release & Publish guide

This file describes the recommended steps to release a module from this
repository and publish it to the Terraform Registry.

1) Prepare the release
----------------------

- Update `CHANGELOG.md`: move Unreleased entries into a new section for the
  planned version (semantic versioning: MAJOR.MINOR.PATCH).
- Run the full test/validation suite locally:

```bash
make fmt
make init
make validate
```

- Ensure each module root you want to publish has a clear `README.md` with
  Inputs/Outputs/Example sections and `versions.tf` with required_version and
  required_providers.

2) Create a tag and GitHub release
----------------------------------

- Choose the version number (e.g., `v1.0.0`).
- Commit all changes and push to your branch.

```bash
git add .
git commit -m "chore(release): prepare v1.0.0"
git push origin feature/s3
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

- Create a GitHub Release (you can do it via web UI or CLI). Use the changelog
  entry as release notes.

3) Publish to Terraform Registry
--------------------------------

- If your repository is public under your GitHub account/org, the Terraform
  Registry can link the repo automatically. Go to:

  https://registry.terraform.io/account/modules

- Click "Publish Module" and follow the prompts (choose the GitHub repo and
  the subdirectory if you want to publish only a single module folder).
- The registry will index the module and make it available under
  `registry.terraform.io/<namespace>/<name>/<provider>`.

4) Post-publish checks
----------------------
- Verify the module page shows Inputs/Outputs and example usage properly.
- Run `terraform init` against the module source address in a small test
  repository to ensure it's consumable by users.

5) Maintenance notes
--------------------
- For breaking changes bump MAJOR and document migration steps in the
  changelog.
- Keep `versions.tf` provider constraints up to date with the latest tested
  provider versions.
