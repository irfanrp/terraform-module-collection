locals {
  common_tags = merge(
    var.tags,
    {
      Module = "ec2"
      Name   = var.name
    }
  )
  ssm_instance_profile_name = var.ssm_instance_profile_name != null ? var.ssm_instance_profile_name : "${var.name}-ssm-instance-profile"
}

# IAM role for SSM
resource "aws_iam_role" "ssm_role" {
  count = var.create_ssm_instance_profile ? 1 : 0
  name  = "${var.name}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach SSM managed instance core policy
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  count      = var.create_ssm_instance_profile ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch agent policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  count      = var.create_ssm_instance_profile && var.enable_cloudwatch_logs ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach CloudWatch logs policy
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  count      = var.create_ssm_instance_profile && var.enable_cloudwatch_logs ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# Custom CloudWatch metrics policy
resource "aws_iam_policy" "cloudwatch_metrics" {
  count = var.create_ssm_instance_profile && var.enable_cloudwatch_metrics ? 1 : 0
  name  = "${var.name}-cloudwatch-metrics-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_metrics" {
  count      = var.create_ssm_instance_profile && var.enable_cloudwatch_metrics ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = aws_iam_policy.cloudwatch_metrics[0].arn
}

# Attach additional IAM policies
resource "aws_iam_role_policy_attachment" "additional_policies" {
  count      = var.create_ssm_instance_profile ? length(var.additional_iam_policies) : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = var.additional_iam_policies[count.index]
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  count = var.create_ssm_instance_profile ? 1 : 0
  name  = local.ssm_instance_profile_name
  role  = aws_iam_role.ssm_role[0].name

  tags = local.common_tags
}

resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.enable_detailed_monitoring
  iam_instance_profile        = var.create_ssm_instance_profile ? aws_iam_instance_profile.ssm_instance_profile[0].name : null
  key_name                    = var.key_name
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  disable_api_termination     = var.disable_api_termination
  placement_group             = var.placement_group
  tenancy                     = var.tenancy

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = merge(local.common_tags, {
      Name = "${var.name}-root-volume-${count.index}"
    })
  }

  tags = merge(local.common_tags, {
    Index = tostring(count.index)
    Name  = "${var.name}-${count.index}"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "this" {
  count = var.associate_public_ip ? var.instance_count : 0

  instance = aws_instance.this[count.index].id

  tags = merge(local.common_tags, {
    Index = tostring(count.index)
    Type  = "eip"
  })
}
