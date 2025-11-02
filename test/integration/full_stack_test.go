package test

import (
	"fmt"
	"testing"
	"time"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/stretchr/testify/assert"
)

func TestFullStackDeployment(t *testing.T) {
	t.Parallel()

	awsRegion := "us-east-1"
	
	terraformOptions := &terraform.Options{
		TerraformDir: "../../",
		Vars: map[string]interface{}{
			"project":      "test-webapp",
			"project_name": "test-webapp",
			"env":          "test",
			"costcenter":   "engineering",
			"aws_region":   awsRegion,
			"owner":        "test-team",
			"instance_type": "t3.micro",
			"key_name":     "test-key",
			"db_engine":    "mysql",
			"db_instance_class": "db.t3.micro",
			"db_allocated_storage": 20,
			"db_name":      "testdb",
			"db_username":  "admin",
			"db_password":  "testpassword123",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, terraformOptions)

	// Deploy the infrastructure
	terraform.InitAndApply(t, terraformOptions)

	// Test VPC
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId)
	
	// Verify VPC exists
	vpc := aws.GetVpcById(t, vpcId, awsRegion)
	assert.Equal(t, "10.0.0.0/16", *vpc.CidrBlock)

	// Test ALB
	albDnsName := terraform.Output(t, terraformOptions, "alb_dns_name")
	assert.NotEmpty(t, albDnsName)
	
	// Test ALB health (with retry)
	url := fmt.Sprintf("http://%s", albDnsName)
	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello", 30, 10*time.Second)

	// Test RDS
	rdsEndpoint := terraform.Output(t, terraformOptions, "rds_endpoint")
	assert.NotEmpty(t, rdsEndpoint)
	
	// Verify RDS instance exists
	rdsInstanceId := terraform.Output(t, terraformOptions, "rds_instance_id")
	rdsInstance := aws.GetRdsInstanceById(t, rdsInstanceId, awsRegion)
	assert.Equal(t, "mysql", *rdsInstance.Engine)
}