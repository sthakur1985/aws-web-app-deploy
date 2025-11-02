# Terraform Testing Makefile

.PHONY: test-unit test-integration test-all validate fmt clean

# Unit Tests - Fast validation without AWS resources
test-unit:
	@echo "Running unit tests..."
	cd unit && go test -v -timeout 10m

# Integration Tests - Full deployment testing
test-integration:
	@echo "Running integration tests..."
	cd integration && go test -v -timeout 60m

# Run all tests
test-all: test-unit test-integration

# Terraform validation
validate:
	@echo "Validating Terraform configuration..."
	terraform -chdir=../ init -backend=false
	terraform -chdir=../ validate
	terraform -chdir=../ fmt -check

# Format Terraform files
fmt:
	terraform -chdir=../ fmt -recursive

# Clean test artifacts
clean:
	@echo "Cleaning test artifacts..."
	find . -name "terraform.tfstate*" -delete
	find . -name ".terraform" -type d -exec rm -rf {} +
	find . -name ".terraform.lock.hcl" -delete

# Security scan
security:
	@echo "Running security scan..."
	tfsec ../

# Plan test
plan-test:
	@echo "Testing terraform plan..."
	terraform -chdir=../ init -backend=false
	terraform -chdir=../ plan -var-file=test.tfvars