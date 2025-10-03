# IAM User submodule

Small, single-purpose module to create an IAM user, optionally add them to groups and create an access key.

## When to use

- Use this submodule when you want to create a single user as a small building block that can be composed into larger configurations (for example, a user onboarding pipeline that creates a user, adds them to groups, and provisions keys).

## Usage

```hcl
module "user_alice" {
  source = "../../modules/iam/submodules/user"
  name   = "alice"
  path   = "/developers/"
  groups = ["developers"]
  create_access_key = true
}

output "alice_user" {
  value = module.user_alice.user_name
}
```

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | string | n/a | yes | IAM user name. |
| `path` | string | `/` | no | IAM path for the user. |
| `groups` | list(string) | `[]` | no | List of existing group names to add the user to. |
| `create_access_key` | bool | `false` | no | Whether to create an access key for the user. |
| `tags` | map(string) | `{}` | no | Optional tags applied to the user resource (provider/version dependent). |
| `create_login_profile` | bool | `false` | no | Create a console login profile for the user. |
| `password_reset_required` | bool | `true` | no | Require password reset on first login for console profile. |
| `pgp_key` | string | `null` | no | Optional PGP key (ascii-armored) to receive an encrypted password from the provider. |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `user_name` | The created IAM user name. | no |
| `access_key_id` | The created access key id (present when `create_access_key = true`). | no |
| `access_key_secret` | The access key secret (present when `create_access_key = true`). | yes — stored in state |

## Security notes

- `access_key_secret` is emitted as a sensitive output and will be stored in the Terraform state file. Treat state as secret: encrypt it, limit access, and rotate keys after creation.
- If you cannot store secrets in state, set `create_access_key = false` and create keys via an out-of-band provisioning step (e.g., a CI job that uses an admin role), or write secrets directly to an external secrets manager.

## Examples

- Creating a developer user and adding to an existing `developers` group; generate an access key for CLI usage.

```hcl
module "user_dev" {
  source = "../../modules/iam/submodules/user"
  name   = "dev-user"
  groups = ["developers"]
  create_access_key = true
}

output "dev_user_key" {
  value     = module.user_dev.access_key_id
  sensitive = false
}
```

## Compatibility

- This submodule assumes the AWS provider (hashicorp/aws) is configured by the calling module.
- Tagging on some IAM sub-resources may differ across provider versions; if tagging is required for all sub-resources, prefer using separate `aws_iam_*_tag` resources in the root configuration.