Composed IAM example

This example shows composing the submodules:
- Create a standalone policy (policy submodule)
- Create a group and attach the policy (group submodule)
- Create an EC2 role and instance profile (role submodule)
- Create a user and add them to the group (user submodule)

Run:

```bash
cd examples/iam-composed
terraform init -backend=false
terraform validate
```
