# VPC Syntax Check Example

🧪 **For syntax validation and testing without AWS credentials**

## Purpose

This example is designed for:
- ✅ Syntax validation (`terraform validate`)
- ✅ Code formatting (`terraform fmt`)  
- ✅ Basic plan generation (may fail at apply)
- ✅ IDE/Editor syntax highlighting
- ❌ **NOT for actual deployment**

## Usage

### 1. Validate Syntax
```bash
cd examples/vpc-syntax-check
terraform init
terraform validate
```

### 2. Check Formatting
```bash
terraform fmt -check
```

### 3. Test Plan (will show what would be created)
```bash
terraform plan
```

## Features

- **No AWS credentials required**
- **Fast feedback for syntax errors**
- **Safe for CI/CD pipelines**
- **Good for development workflow**

## What This Tests

✅ Terraform syntax  
✅ Module references  
✅ Variable types  
✅ Resource dependencies  
✅ Output definitions  

## Limitations

⚠️ **This example will NOT:**
- Actually create AWS resources
- Validate AWS-specific configurations
- Test real network connectivity
- Verify AWS permissions

## Development Workflow

```bash
# 1. Make changes to modules
vim ../../modules/vpc/main.tf

# 2. Quick syntax check
cd examples/vpc-syntax-check
terraform validate

# 3. Format code
terraform fmt -recursive ../..

# 4. Test plan (optional)
terraform plan
```

For real AWS testing, use:
- `examples/vpc-basic/` - Real AWS
- `examples/vpc-localstack/` - Local AWS simulation