# EC2 Advanced Example

This example demonstrates the full capabilities of the enhanced EC2 Terraform module with enterprise-grade features.

## Features Demonstrated

### Infrastructure
- **VPC with NAT Gateway** - Private subnets with internet access
- **Placement Groups** - Cluster placement for high performance
- **Multiple Availability Zones** - High availability deployment
- **Security Groups** - Network-level security controls

### Security
- **Private Subnet Deployment** - Instances not directly accessible from internet
- **Bastion Host** - Secure SSH access through jump server
- **Instance Termination Protection** - Prevents accidental termination
- **Custom IAM Policies** - Least privilege access
- **UFW Firewall** - Host-level firewall configuration
- **Fail2ban** - Intrusion prevention system

### Monitoring & Observability
- **Enhanced CloudWatch Monitoring** - Detailed metrics collection
- **Custom CloudWatch Metrics** - CPU, memory, disk, network metrics
- **Centralized Logging** - Application and system logs in CloudWatch
- **Health Check Endpoints** - Application health monitoring

### Management
- **SSM Integration** - Secure shell access without SSH keys
- **User Data Scripts** - Automated instance configuration
- **Multiple Instance Types** - Application servers and bastion host
- **Tag-based Organization** - Consistent resource tagging

## Architecture

```
Internet Gateway
       │
   Public Subnets (Bastion)
       │
   NAT Gateway
       │
   Private Subnets (App Servers)
   ├── app-server-0
   ├── app-server-1
   └── app-server-2
```

## Deployment

### Prerequisites
1. Update `variables.tf` with your SSH public key
2. Modify `allowed_ssh_cidr_blocks` to your IP range
3. Ensure you have appropriate AWS credentials

### Deploy
```bash
cd examples/ec2-advanced
terraform init
terraform plan
terraform apply
```

### Example terraform.tfvars
```hcl
aws_region        = "us-west-2"
vpc_name          = "my-advanced-app"
instance_type     = "t3.large"
environment       = "production"
project_name      = "my-application"

# Replace with your actual SSH public key
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC..."

# Restrict SSH access to your IP
allowed_ssh_cidr_blocks = ["203.0.113.0/24"]
```

## Access Methods

### 1. AWS Session Manager (Recommended)
```bash
# List instances
aws ec2 describe-instances --filters "Name=tag:Name,Values=app-server*" \
  --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name]' \
  --output table

# Connect to any instance
aws ssm start-session --target <instance-id>
```

### 2. SSH via Bastion Host
```bash
# SSH to bastion (replace with actual IPs and key path)
ssh -i /path/to/private/key ubuntu@<bastion-public-ip>

# From bastion, SSH to app servers
ssh ubuntu@<app-server-private-ip>
```

### 3. Web Interface
Since app servers are in private subnets, you can set up port forwarding through the bastion:

```bash
# Forward port 80 from app server through bastion
ssh -i /path/to/private/key -L 8080:<app-server-private-ip>:80 ubuntu@<bastion-public-ip>

# Access web interface at http://localhost:8080
```

## Monitoring

### CloudWatch Dashboards
The instances send comprehensive metrics to CloudWatch:
- CPU usage (all states)
- Memory utilization
- Disk usage and I/O
- Network statistics
- Process counts

### Log Groups
Application logs are automatically forwarded to:
- `/aws/ec2/advanced/nginx/access` - Web server access logs
- `/aws/ec2/advanced/nginx/error` - Web server error logs
- `/aws/ec2/advanced/system/syslog` - System logs
- `/aws/ec2/advanced/system/auth` - Authentication logs
- `/aws/ec2/advanced/security/fail2ban` - Security logs

## Scaling Considerations

For production scaling, consider:
1. **Auto Scaling Groups** instead of fixed instance count
2. **Application Load Balancer** for traffic distribution
3. **RDS Database** for persistent data
4. **ElastiCache** for session management
5. **S3** for static assets

## Security Best Practices

This example implements several security best practices:
- ✅ Private subnet deployment
- ✅ Least privilege IAM policies
- ✅ Host-based firewalls
- ✅ Intrusion detection
- ✅ Centralized logging
- ✅ No hard-coded credentials
- ✅ Encrypted storage

## Cost Optimization

- Use **t3.micro** for development
- Consider **Spot Instances** for non-critical workloads
- Implement **Instance Scheduler** for dev/test environments
- Monitor costs with **AWS Cost Explorer**

## Clean Up
```bash
terraform destroy
```

⚠️ **Note**: Termination protection is enabled on app servers. You'll need to disable it before destroying:

```bash
# Disable termination protection
aws ec2 modify-instance-attribute --instance-id <instance-id> --no-disable-api-termination

# Then run destroy
terraform destroy
```