# IAM (wrapper)

Small wrapper module that composes focused IAM submodules: role, policy, user, group and oidc-provider.

Keep this module as a high-level convenience. For advanced use prefer composing the submodules directly.

Why use the wrapper
- One module call to create roles, instance profiles, standalone policies, users and groups
- Inputs are maps/lists so you can create many identities/policies in a single call
- Works well for small infra stacks and examples

Quick example (minimal)
```hcl
module "iam" {
  source = "../../modules/iam"

  name_prefix = "app-"

  # create a standalone policy
  policies = {
    "readonly-s3" = jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "*" }]
    })
  }

  # create a user and add to group
  groups = {
    devs = { managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"] }
  }

  users = {
    alice = { groups = ["devs"], create_access_key = true }
  }
}
```

Key inputs (high level)
- `policies` — map(name => policy JSON)
- `roles` — created via `create_role` + role-related vars (see `variables.tf`)
- `users` — map of users (path, groups, managed_policy_arns, create_access_key)
- `groups` — map of groups (managed_policy_arns, inline_policies)
- `oidc_providers` — map for OIDC provider creation

Outputs
- `role_name`, `role_arn` — when a role is created
- `instance_profile_name` — when instance profile is created
- `policy_arns` — map of created standalone policy name => ARN
- `user_access_key_ids` / `user_access_key_secrets` — access key outputs (sensitive)

Notes
- Prefer composing the submodules directly for complex setups — see `modules/iam/submodules/`.
- Access keys and secrets are exposed in state; rotate and secure your backend.

Example folder: `examples/iam-composed` (more examples under `examples/iam-*`).

License: MIT
