Example: IAM users + groups

This example demonstrates creating IAM groups, attaching policies to groups, creating IAM users, adding users to groups, and creating access keys for specific users.

Important notes:
- Policies are attached to groups (not users) in this example.
- If `create_access_key = true` for a user, the module will create an access key and expose the id and secret as outputs. Secrets are marked sensitive and will be stored in Terraform state. Secure your state backend.

How to try:

```bash
cd examples/iam-users
terraform init
terraform validate
terraform plan
```
