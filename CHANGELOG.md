## v0.0.2 - 2025-10-05

### Added
- feat: Add AWS RDS snapshot export module with S3 bucket and IAM role configuration

### Changed
- chore: Remove release drafter configuration files and clean up S3 bucket ACL formatting


[v0.0.1-final...v0.0.2]: https://github.com/irfanrp/terraform-module-collection/compare/v0.0.1-final...v0.0.2
[v0.0.2]: https://github.com/irfanrp/terraform-module-collection/releases/tag/v0.0.2

## v0.0.2 - 2025-10-05

## [0.0.2] - 2025-10-05

### 🚀 Features

- Add AWS RDS snapshot export module with S3 bucket and IAM role configuration
- Add automated changelog update on tag creation
- Enhance CI workflow to install git-cliff for improved changelog generation
- Update CI workflow to enhance changelog generation and upload artifact
- Add changelog generation workflow for release events

### 🐛 Bug Fixes

- Correct config-name path in release drafter workflow
- Update release drafter configuration and improve workflow clarity
- Update GEMINI_API_KEY references in PR assistant workflow and upgrade release drafter version
- Correct config-name path in release drafter workflow
- Update GITHUB_TOKEN reference in release drafter workflow
- Update GITHUB_TOKEN reference and integrate Google Generative API for AI summarization
- Update PR assistant workflow to use OPENAI_API_KEY and adjust API call for AI summarization
- Update PR assistant to use GEMINI_API_KEY for AI summarization and improve error handling
- Update PR assistant to use Gemini 2.5 model for AI summarization
- Update GEMINI_API_KEY validation URL to use the correct API version
- Update API calls in PR summarizer and assistant to use the correct endpoint and improve error handling
- Remove temperature parameter from payload to comply with API requirements
- Add handling for empty diff cases in PR summarizer
- Simplify README content and improve clarity on module usage and structure
- Correct branch creation for changelog updates in CI workflow
- Enhance changelog generation to filter commits by modules and examples directories

### ⚙️ Miscellaneous Tasks

- Remove release drafter configuration files and clean up S3 bucket ACL formatting
- *(release)* Update CHANGELOG for v0.0.2
- *(release)* Update CHANGELOG for v0.0.3
- *(release)* Update CHANGELOG for v0.0.2
- Remove 'main' branch references from CI workflow
- *(release)* Update CHANGELOG for v0.0.2
## [0.0.1-final] - 2025-10-04

### 🚀 Features

- Add comprehensive Terraform module collection for AWS
- Update CI workflow to install and run tfsec for security scanning
- Update tfsec installation method in CI workflow to use official script
- Enhance PR Assistant workflow with improved AI summarization and error handling
- *(ec2)* Enhance EC2 module with advanced features and user data scripts
- *(s3)* Add S3 module with enhanced features including versioning, encryption, and logging
- *(ec2)* Add support for assigning optional fixed private IPs to instances
- *(iam)* Enhance README with detailed module features, inputs, outputs, and examples
- *(iam)* Enhance IAM user module with login profile and password management features
- *(iam)* Update README inputs section for clarity and completeness
- *(iam)* Refactor IAM policy module to support multiple policies and update outputs
- *(cloudflare)* Enhance Cloudflare module with provider support and improved configurations
- *(iam)* Refactor policy module to support multiple policies and update outputs
- *(s3)* Refactor S3 module to support multi-bucket configuration with improved README and examples
- *(cloudfront-oac)* Add CloudFront OAC module with S3 bucket policy and comprehensive README
- *(s3-cloudfront-oac)* Add comprehensive README for S3 and CloudFront OAC example, detailing usage and IAM permissions
- Add quick-test target for syntax validation in Makefile
- Add versions.tf files to examples and modules to enforce Terraform version constraints

### 🐛 Bug Fixes

- Improve validation process in Makefile to handle directories more robustly

### 🚜 Refactor

- Improve formatting and consistency in S3 and CloudFront OAC modules
- Remove obsolete testing targets from Makefile

### 📚 Documentation

- Enhance README with detailed S3 module features, usage examples, and input/output specifications
- Revise README for clarity and structure improvements
- *(cloudflare)* Update README with usage examples and notes for DNS submodule
- *(cloudflare)* Update README with additional usage examples for tunnel module
- *(iam)* Enhance README with usage examples for IAM wrapper and submodules
- *(iam)* Refactor README for IAM wrapper and OIDC provider submodule for clarity and formatting
- *(cloudfront-oac)* Enhance README with detailed inputs, outputs, and usage examples

### 🎨 Styling

- Clean up comments and formatting in EC2 module configurations
- Align variable assignments and clean up formatting in S3 module
- Clean up formatting in S3 module locals
- Update tflint command to capture junit XML output and add optional human-readable output
- *(iam)* Adjust formatting for consistency in main.tf and README.md

### ⚙️ Miscellaneous Tasks

- Remove LocalStack example files and configurations

[v0.0.1-final...v0.0.2]: https://github.com/irfanrp/terraform-module-collection/compare/v0.0.1-final...v0.0.2
[v0.0.2]: https://github.com/irfanrp/terraform-module-collection/releases/tag/v0.0.2

