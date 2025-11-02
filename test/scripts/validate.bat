@echo off
REM Terraform validation script for Windows

echo Starting Terraform validation...

cd /d "%~dp0..\.."

echo Initializing Terraform...
terraform init -backend=false

echo Validating Terraform configuration...
terraform validate

echo Checking Terraform formatting...
terraform fmt -check -recursive

echo Creating execution plan...
terraform plan -var-file=test.tfvars -out=test.tfplan

echo Validation completed successfully!

del test.tfplan