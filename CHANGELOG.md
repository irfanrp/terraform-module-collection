# Changelog

All notable changes to this repository will be documented in this file.

Format
- We follow a simple "Keep a changelog" style with an Unreleased section and
  dated release sections using semantic versioning (MAJOR.MINOR.PATCH).

Template
---------

## [Unreleased]

- Added: short description of addition
- Changed: short description of change
- Fixed: short description of bugfix

### Example entry

## [Unreleased]

- Added: `modules/s3/submodules/cloudfront_oac` — CloudFront Origin Access
  Control submodule with optional restrictive S3 bucket policy.
- Changed: Added `versions.tf` to modules and examples to pin Terraform/provider
  constraints for reproducible validation.
- Fixed: Makefile `quick-test` and validate flow to avoid failing when example
  folders are absent.

Release notes
-------------
- When cutting a release, move Unreleased entries into a new section labelled
  with the version and date, for example:

```
## [1.0.0] - 2025-10-05

- Added: initial public release of the `s3` wrapper and `cloudfront_oac` submodule.
- Changed: provider constraints tightened; examples include `versions.tf`.
```

Guidelines
----------
- Keep entries concise and actionable.
- Group entries by type: Added, Changed, Fixed, Deprecated, Removed, Security.
