package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../../modules/vpc",
		Vars: map[string]interface{}{
			"project":    "test-project",
			"env":        "test",
			"costcenter": "test-team",
			"vpc_cidr":   "10.0.0.0/16",
			"public_subnet_cidrs":  []string{"10.0.1.0/24", "10.0.2.0/24"},
			"private_subnet_cidrs": []string{"10.0.3.0/24", "10.0.4.0/24"},
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)

	// Validate Terraform configuration
	terraform.InitAndValidate(t, terraformOptions)
	
	// Plan and verify no errors
	terraform.InitAndPlan(t, terraformOptions)
	
	// Apply and get outputs
	terraform.InitAndApply(t, terraformOptions)
	
	// Test outputs
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId)
	
	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	assert.Len(t, publicSubnetIds, 2)
	
	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnet_ids")
	assert.Len(t, privateSubnetIds, 2)
}