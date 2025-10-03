# Create a standalone policy
module "policy" {
  source = "../../modules/iam/submodules/policy"
  policies = {
    "example-read-only" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = ["s3:ListBucket", "s3:GetObject"],
          Resource = ["arn:aws:s3:::example-bucket", "arn:aws:s3:::example-bucket/*"]
        }
      ]
    })
  }
}

# Create a group and attach the new policy to it
module "group_developers" {
  source              = "../../modules/iam/submodules/group"
  name                = "developers"
  # using the policy module output map
  managed_policy_arns = [module.policy.policy_arns["example-read-only"]]
  inline_policies = {
    dev_ssm = jsonencode({
      Version   = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["ssm:DescribeInstanceInformation"], Resource = "*" }]
    })
  }
}

# Create a role for EC2 and an instance profile
module "role_ec2" {
  source                  = "../../modules/iam/submodules/role"
  name                    = "example-ec2-role"
  assume_services         = ["ec2.amazonaws.com"]
  managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  create_instance_profile = true
}

# Create a user and add to the developers group
module "user_alice" {
  source            = "../../modules/iam/submodules/user"
  name              = "alice"
  path              = "/developers/"
  groups            = [module.group_developers.group_name]
  create_access_key = true
}