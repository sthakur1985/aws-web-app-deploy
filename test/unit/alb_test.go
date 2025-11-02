package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestALBModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/alb",
		Vars: map[string]interface{}{
			"project_name": "test-project",
			"env":          "test",
			"costcenter":   "test-team",
			"vpc_id":       "vpc-12345678",
			"public_subnet_ids": []string{"subnet-12345678", "subnet-87654321"},
		},
		NoColor: true,
	}

	// Only validate and plan for unit test (no apply)
	terraform.InitAndValidate(t, terraformOptions)
	terraform.InitAndPlan(t, terraformOptions)
	
	// Test plan output contains expected resources
	planOutput := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, planOutput, "aws_lb.this")
	assert.Contains(t, planOutput, "aws_lb_target_group.this")
	assert.Contains(t, planOutput, "aws_security_group.alb_sg")
}