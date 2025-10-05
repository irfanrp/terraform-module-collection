## v0.0.2 - 2025-10-05

### Added
- feat: Add AWS RDS snapshot export module with S3 bucket and IAM role configuration (by Irfan Rizkianto Pratama)

### Changed
- chore: Remove release drafter configuration files and clean up S3 bucket ACL formatting (by Irfan Rizkianto Pratama)


[v0.0.1-final...v0.0.2]: https://github.com/irfanrp/terraform-module-collection/compare/v0.0.1-final...v0.0.2
[v0.0.2]: https://github.com/irfanrp/terraform-module-collection/releases/tag/v0.0.2

## v0.0.3 - 2025-10-05
# Changelog

All notable changes to this project are documented in this file.

The format follows a simple grouped layout (Added / Changed / Fixed / Docs / Security).

## [Unreleased]

### Added

- 

### Changed

- 

### Fixed

- 

---

## [v0.0.3] - 2025-10-05

### Added

- CI job to auto-generate changelog sections and open a PR for review.

### Changed

- Improve PR assistant to use the Gemini model and fix API endpoint handling.
- Simplify top-level README and repo documentation.

### Fixed

- Fix changelog branch creation and CI workflow issues when running on tags.
- Handle empty-diff cases in PR summarizer and remove invalid payload fields.

---

## [v0.0.2] - 2025-10-05

### Added

- AWS RDS snapshot export helper module (`modules/rds/aws-rds-snapshot-export`).

### Changed

- Rework S3 module into wrapper + submodules (bucket, policy, cloudfront_oac).

### Fixed

- Multiple workflow fixes (release drafter, PR assistant authentication and validation).

---

For details on releases, you can add comparison links at the bottom in the form:

[v0.0.2]: https://github.com/OWNER/REPO/releases/tag/v0.0.2
[v0.0.3]: https://github.com/OWNER/REPO/releases/tag/v0.0.3

Replace OWNER/REPO with your GitHub owner and repository name.
