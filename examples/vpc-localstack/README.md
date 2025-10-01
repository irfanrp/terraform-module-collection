# VPC LocalStack Example

This example demonstrates how to test the VPC module locally using LocalStack.

## What is LocalStack?

LocalStack is a fully functional local AWS cloud stack that allows you to develop and test your cloud applications offline.

## Setup

### 1. Install LocalStack

**Option A: Using Docker (Recommended)**
```bash
# Install LocalStack
pip install localstack

# Start LocalStack
localstack start
```

**Option B: Using Docker Compose**
```yaml
# docker-compose.yml
version: '3.8'
services:
  localstack:
    container_name: localstack_main
    image: localstack/localstack
    ports:
      - "127.0.0.1:4566:4566"
    environment:
      - SERVICES=ec2,vpc,iam
      - DEBUG=1
      - DATA_DIR=/tmp/localstack/data
    volumes:
      - "/tmp/localstack:/tmp/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

### 2. Verify LocalStack is Running

```bash
curl http://localhost:4566/_localstack/health
```

### 3. Run Terraform

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply (to LocalStack)
terraform apply
```

## Features

✅ **No AWS Credentials Required**  
✅ **Local Testing Environment**  
✅ **Fast Feedback Loop**  
✅ **Cost-Free Testing**  

## What Gets Created

- VPC with CIDR `10.0.0.0/16`
- Public subnets in 2 AZs  
- Private subnets in 2 AZs
- Internet Gateway
- NAT Gateways
- Security groups

## Cleanup

```bash
# Destroy resources
terraform destroy

# Stop LocalStack
localstack stop
```

## Limitations

⚠️ **LocalStack Community Edition** has some limitations:
- Limited AWS services
- Some advanced features may not work
- Not 100% AWS-compatible

For production testing, use real AWS credentials or LocalStack Pro.

## Troubleshooting

**LocalStack not responding?**
```bash
# Check if LocalStack is running
docker ps | grep localstack

# Check logs
localstack logs
```

**Connection refused?**
```bash
# Make sure port 4566 is available
lsof -i :4566
```