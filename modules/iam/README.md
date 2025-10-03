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

1) Basic role + instance profile for EC2 (SSM)

```hcl
module "iam_ssm" {
  source = "../../modules/iam"

  name_prefix             = "ec2-ssm-"
  assume_services         = ["ec2.amazonaws.com"]
  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  create_instance_profile = true
}

module "ec2" {
  source = "../../modules/ec2"

  # ...other inputs
  create_ssm_instance_profile = false
  iam_instance_profile         = module.iam_ssm.instance_profile_name
}
```

2) Create standalone policy and attach to a group and user

```hcl
module "iam" {
  source = "../../modules/iam"

  policies = {
    "readonly-s3" = jsonencode({
      Version = "2012-10-17"
      Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "*" }]
    })
  }

  groups = {
    devs = {
      managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      inline_policies = {
        extra = jsonencode({ Version = "2012-10-17", Statement = [] })
      }
    }
  }

  users = {
    alice = {
      managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      groups = ["devs"]
      create_access_key = true
    }
  }
}
```

3) Cross-account role + OIDC provider (EKS example)

```hcl
module "iam_eks" {
  source = "../../modules/iam"

  name_prefix = "eks-cluster-"
  assume_services = ["eks.amazonaws.com"]
  cross_account_principals = ["arn:aws:iam::123456789012:role/ExternalAdminRole"]
}

module "oidc" {
  source = "../../modules/iam"
  oidc_providers = {
    eks = {
      url = "https://oidc.eks.region.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E"
      client_id_list = ["sts.amazonaws.com"]
      thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0d3b7a3f6"]
    }
  }
}
```

Notes and recommendations
- Inline and standalone policies must be valid JSON. The module attaches the policy bodies you supply.
- When providing `private` data such as access keys in examples, prefer creating them with CI secrets and rotate regularly.
- Provider compatibility: if you need tags or provider-specific arguments on particular IAM sub-resources, verify your `hashicorp/aws` provider version and add tags via separate `aws_iam_*_tag` resources if needed.
- Validation: I can add `validation` blocks for `users`, `groups`, and `oidc_providers` to fail fast on common mistakes (recommended for strict inputs).

Composed (recommended) pattern
--------------------------------
This repository includes small, single-purpose IAM submodules under `modules/iam/submodules/` (for example: `user`, `group`, `policy`, `role`, `oidc-provider`). We recommend composing these submodules in your root configuration when you want clear, testable building blocks.

Why compose?
- Smaller modules are easier to reason about, test, and reuse across projects.
- Composed examples surface input/output mismatches earlier and reduce accidental coupling between resources.

See `examples/iam-composed` for a runnable example that shows how to:
- create a standalone policy (policy submodule)
- create a group and attach the policy (group submodule)
- create a role and instance profile for EC2 (role submodule)
- create a user and add them to the group (user submodule)

Example quickstart
1. cd examples/iam-composed
2. terraform init -backend=false
3. terraform validate

Notes about secrets
- The user submodule can create access keys and exposes them as sensitive outputs. These secrets will be stored in state; secure your backend and rotate keys regularly.

If you want, I can add a few curated examples (EKS, cross-account trust, or user onboarding) and input validation next. Tell me which example to add first.