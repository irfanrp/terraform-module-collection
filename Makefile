.PHONY: help init plan apply destroy validate fmt lint clean test docs

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Terraform operations
init: ## Initialize Terraform in all example directories
	@echo "🚀 Initializing Terraform..."
	@for dir in examples/*/; do \
		echo "Initializing $$dir"; \
		cd "$$dir" && terraform init && cd ../..; \
	done

validate: ## Validate Terraform configuration
	@echo "✅ Validating Terraform configuration..."
	@for dir in examples/*/; do \
		echo "Validating $$dir"; \
		cd "$$dir" && terraform validate && cd ../..; \
	done
	@for dir in modules/*/; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "Validating $$dir"; \
			cd "$$dir" && terraform init -backend=false && terraform validate && cd ../..; \
		fi \
	done

fmt: ## Format Terraform files
	@echo "🎨 Formatting Terraform files..."
	@terraform fmt -recursive .

plan: ## Show Terraform plan for VPC example
	@echo "📋 Creating Terraform plan..."
	@cd examples/vpc-basic && terraform plan

apply: ## Apply Terraform configuration for VPC example
	@echo "⚡ Applying Terraform configuration..."
	@cd examples/vpc-basic && terraform apply

destroy: ## Destroy Terraform infrastructure for VPC example
	@echo "💥 Destroying Terraform infrastructure..."
	@cd examples/vpc-basic && terraform destroy

# Development tools
lint: ## Run terraform lint (requires tflint)
	@echo "🔍 Running terraform lint..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --recursive; \
	else \
		echo "⚠️  tflint not installed. Install it with: curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash"; \
	fi

clean: ## Clean Terraform files
	@echo "🧹 Cleaning Terraform files..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "terraform.tfstate*" -delete
	@find . -name ".terraform.lock.hcl" -delete

test: ## Run tests (requires terratest)
	@echo "🧪 Running tests..."
	@if [ -d "test" ]; then \
		cd test && go test -v; \
	else \
		echo "⚠️  No test directory found"; \
	fi

docs: ## Generate documentation (requires terraform-docs)
	@echo "📚 Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		for dir in modules/*/; do \
			if [ -f "$$dir/main.tf" ]; then \
				echo "Generating docs for $$dir"; \
				terraform-docs markdown table "$$dir" > "$$dir/README.md"; \
			fi \
		done; \
	else \
		echo "⚠️  terraform-docs not installed. Install it with: brew install terraform-docs"; \
	fi

# Quick setup
setup: ## Setup development environment
	@echo "🔧 Setting up development environment..."
	@if ! command -v terraform >/dev/null 2>&1; then \
		echo "❌ Terraform not found. Please install Terraform first."; \
		exit 1; \
	fi
	@echo "✅ Terraform found: $$(terraform version)"
	@make fmt
	@make init
	@make validate
	@echo "🎉 Setup complete!"

# Example specific operations
vpc-init: ## Initialize VPC example
	@cd examples/vpc-basic && terraform init

vpc-plan: ## Plan VPC example
	@cd examples/vpc-basic && terraform plan

vpc-apply: ## Apply VPC example
	@cd examples/vpc-basic && terraform apply

vpc-destroy: ## Destroy VPC example
	@cd examples/vpc-basic && terraform destroy

# Local testing (no AWS credentials needed)
test-syntax: ## Test syntax without AWS credentials
	@echo "🧪 Testing syntax..."
	@cd examples/vpc-syntax-check && terraform init -upgrade
	@cd examples/vpc-syntax-check && terraform validate
	@echo "✅ Syntax validation passed!"

test-localstack: ## Test with LocalStack (requires LocalStack running)
	@echo "🐳 Testing with LocalStack..."
	@if ! curl -s http://localhost:4566/_localstack/health > /dev/null; then \
		echo "❌ LocalStack not running. Start it with: localstack start"; \
		exit 1; \
	fi
	@cd examples/vpc-localstack && terraform init -upgrade
	@cd examples/vpc-localstack && terraform plan
	@echo "✅ LocalStack test passed!"

quick-test: ## Quick syntax validation (fastest)
	@echo "⚡ Quick syntax test..."
	@terraform fmt -check -recursive . || (echo "❌ Format check failed. Run 'make fmt' to fix." && exit 1)
	@cd examples/vpc-syntax-check && terraform init -upgrade > /dev/null 2>&1
	@cd examples/vpc-syntax-check && terraform validate
	@echo "✅ Quick test passed!"