# Terraform Testing Guide

## Testing Strategy

### 🧪 Unit Tests
- **Purpose**: Validate individual modules without deploying resources
- **Tools**: Terratest, terraform validate/plan
- **Speed**: Fast (< 5 minutes)
- **Cost**: Free

### 🔗 Integration Tests  
- **Purpose**: Test full stack deployment and functionality
- **Tools**: Terratest with AWS SDK
- **Speed**: Slow (30-60 minutes)
- **Cost**: AWS resources created/destroyed

## Setup

### Prerequisites
```bash
# Install Go
go version

# Install Terraform
terraform version

# Configure AWS credentials
aws configure
```

### Install Dependencies
```bash
cd test
go mod tidy
```

## Running Tests

### Unit Tests (Recommended for CI/CD)
```bash
# Validate configuration
test\scripts\validate.bat

# Run unit tests
cd test\unit
go test -v -timeout 10m

# Or use Makefile
make test-unit
```

### Integration Tests (Pre-deployment)
```bash
# Run integration tests
cd test\integration
go test -v -timeout 60m

# Or use Makefile
make test-integration
```

### Quick Validation
```bash
# Format check
terraform fmt -check -recursive

# Validate syntax
terraform validate

# Security scan (install tfsec first)
tfsec .

# Plan test
terraform plan -var-file=test.tfvars
```

## Test Structure

```
test/
├── unit/                 # Unit tests for individual modules
│   ├── vpc_test.go      # VPC module tests
│   ├── alb_test.go      # ALB module tests
│   └── rds_test.go      # RDS module tests
├── integration/         # Full stack integration tests
│   └── full_stack_test.go
├── scripts/            # Helper scripts
│   └── validate.bat    # Validation script
├── go.mod             # Go dependencies
├── Makefile          # Test automation
└── README.md         # This file
```

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Terraform Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-go@v3
        with:
          go-version: '1.19'
      - name: Run Unit Tests
        run: |
          cd test
          make test-unit
```

### Test Commands
```bash
# All tests
make test-all

# Unit tests only
make test-unit  

# Integration tests only
make test-integration

# Validation only
make validate

# Security scan
make security

# Clean artifacts
make clean
```

## Best Practices

1. **Unit Tests**: Run on every commit
2. **Integration Tests**: Run before deployment
3. **Use test.tfvars**: Separate test configuration
4. **Cleanup**: Always destroy test resources
5. **Parallel Testing**: Use t.Parallel() for speed
6. **Timeouts**: Set appropriate test timeouts
7. **Assertions**: Test outputs and resource properties