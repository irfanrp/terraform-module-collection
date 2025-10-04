# IAM (wrapper)

Small wrapper module that composes focused IAM submodules: role, policy, user, group and oidc-provider.

Keep this module as a high-level convenience. For advanced use prefer composing the submodules directly.

Why use the wrapper
- One module call to create roles, instance profiles, standalone policies, users and groups
- Inputs are maps/lists so you can create many identities/policies in a single call
# IAM wrapper & submodules

This folder provides a small wrapper (`modules/iam`) that composes focused submodules:
- `role`, `policy`, `user`, `group`, and `oidc-provider`.

Use the wrapper for convenience (single call for common patterns). For complex or highly controlled setups prefer composing the submodules directly.

Quick wrapper example
```hcl
module "iam" {
  source = "../../modules/iam"

  name_prefix = "app-"

  policies = {
    "readonly-s3" = jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "*" }]
    })
  }

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
- `users` — map of users (path, groups, managed_policy_arns, create_access_key)
- `groups` — map of groups (managed_policy_arns, inline_policies)
- `oidc_providers` — map for OIDC provider creation

Key outputs
- `role_name`, `role_arn` — when role is created
- `instance_profile_name` — when instance profile is created
- `policy_arns` — map of created standalone policy name => ARN
- `user_access_key_ids` / `user_access_key_secrets` — access key outputs (sensitive)

Quick per-submodule examples

- Role (EC2 + instance profile)

```hcl
module "role_ec2" {
  source = "../../modules/iam/submodules/role"
  name = "app-ec2-role"
  assume_services = ["ec2.amazonaws.com"]
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
}
```

- Policy (map)

```hcl
module "policy" {
  source = "../../modules/iam/submodules/policy"
  policies = {
    "readonly-s3" = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "*" }] })
  }
}
```

- Group

```hcl
module "group_devs" {
  source = "../../modules/iam/submodules/group"
  name = "devs"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
```

- User (for_each)

```hcl
locals {
  users = {
    alice = { groups = ["devs"], create_access_key = true }
  }
}

module "user" {
  source = "../../modules/iam/submodules/user"
  for_each = local.users
  name = each.key
  groups = try(each.value.groups, [])
  create_access_key = try(each.value.create_access_key, false)
}
```

- OIDC provider

```hcl
module "oidc_eks" {
  source = "../../modules/iam/submodules/oidc-provider"
  url = "https://oidc.eks.region.amazonaws.com/id/EXAMPLE"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a..."]
}
```

Notes
- Access keys and console passwords are sensitive and will appear in state; secure your backend and rotate keys.
- For controlled setups prefer composing submodules directly so you can manage dependencies and outputs tightly.

Examples: see `examples/iam-composed` and `examples/iam-submodules/*` for per-submodule examples.

License: MIT
  for_each = local.users
