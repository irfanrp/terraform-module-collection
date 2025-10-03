# IAM module

This module creates an IAM role with optional managed policy attachments and inline policies. It can also create an instance profile for EC2 usage.

Features:
- Create a role (configurable name or prefix)
- Attach managed policy ARNs (list)
- Attach inline policies (map of name -> JSON string)
# IAM module

This module provides a compact, reusable set of IAM building blocks for Terraform:

- Roles (with configurable assume role policy and attachments)
- Instance profiles for EC2
- Standalone policies (create and reference)
- Users and groups with managed/inline policy attachments and optional access keys
- Service-linked roles
- Cross-account principals in role trust policies
- OIDC providers

Design goals
- Small, composable, and driven by maps/lists so you can create many users/groups/policies cleanly from variants
- Non-opinionated defaults but easy to opt into common patterns (EC2/SSM, cross-account, OIDC)

Compatibility note
- Some AWS provider versions differ in supported arguments (for example tags on certain IAM sub-resources). The module avoids provider-specific arguments where they caused parsing issues. If you require tags for specific resources, consider adding them with separate resources in your root config or confirm your provider version supports tags.

Main inputs (high level)
- `role_name` / `name_prefix` — control role naming
- `assume_services` / `cross_account_principals` / `assume_role_policy` — control who can assume the role
- `managed_policy_arns` — list of managed ARNs to attach to the role
- `inline_policies` — map(name => policy JSON) to attach inline to the role
- `create_instance_profile` / `instance_profile_name` — create an instance profile for EC2
- `policies` — map(name => policy JSON) for standalone policies
- `users` — map of user definitions (see examples)
- `groups` — map of group definitions (see examples)
- `service_linked_roles` — list of service names for service-linked roles
- `oidc_providers` — map(name => { url, client_id_list, thumbprint_list })

Outputs
- `role_name`, `role_arn` — role identifiers
- `instance_profile_name`, `instance_profile_arn` — instance profile identifiers (if created)
- `policy_arns` — map of created standalone policy name => ARN
- `user_names`, `group_names` — lists of created user/group names
- `oidc_provider_arns` — map of created OIDC provider logical name => ARN
- `service_linked_roles` — list of created service-linked role service names

Examples
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
