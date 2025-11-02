package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestRDSModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/rds",
		Vars: map[string]interface{}{
			"project":                "test-project",
			"vpc_id":                 "vpc-12345678",
			"private_subnet_ids":     []string{"subnet-12345678", "subnet-87654321"},
			"ec2_security_group_id":  "sg-12345678",
			"engine":                 "mysql",
			"instance_class":         "db.t3.micro",
			"allocated_storage":      20,
			"db_name":               "testdb",
			"username":              "admin",
			"password":              "testpassword123",
			"skip_final_snapshot":   true,
			"deletion_protection":   false,
		},
		NoColor: true,
	}

	// Validate and plan only (no apply for unit test)
	terraform.InitAndValidate(t, terraformOptions)
	planOutput := terraform.InitAndPlan(t, terraformOptions)
	
	// Verify expected resources in plan
	assert.Contains(t, planOutput, "aws_db_instance.this")
	assert.Contains(t, planOutput, "aws_db_subnet_group.rds-sub")
	assert.Contains(t, planOutput, "aws_security_group.rds_sg")
	
	// Verify security configurations
	assert.Contains(t, planOutput, "storage_encrypted")
	assert.Contains(t, planOutput, "publicly_accessible = false")
}