package test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

func setupOptions(t *testing.T, prefix string, dir string, region string, plan string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
	})
	options.TerraformVars = map[string]interface{}{
		"access_tags":    permanentResources["accessTags"],
		"region":         region,
		"prefix":         options.Prefix,
		"resource_group": resourceGroup,
		"resource_tags":  options.Tags,
		"plan":           plan,
	}
	return options
}

// Run `lite` plan for basic example
func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	region := validRegionsLite[common.CryptoIntn(len(validRegionsLite))]
	plan := "lite"
	options := setupOptions(t, "wxd-basic", basicExampleDir, region, plan)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// Run `lakehouse-enterprise` or `lakehouse-enterprise-mcsp` based on the randomly selected region for advanced example
func TestRunAdvancedExample(t *testing.T) {
	t.Parallel()

	region := validRegionsEnterprise[common.CryptoIntn(len(validRegionsEnterprise))]
	plan := "lakehouse-enterprise"
	if region == "au-syd" || region == "ca-tor" {
		plan = "lakehouse-enterprise-mcsp"
	}
	options := setupOptions(t, "wxd-advanced", advancedExampleDir, region, plan)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
