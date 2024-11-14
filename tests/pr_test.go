// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"math/rand"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const basicExampleDir = "examples/basic"

// Current supported regions
var validRegions = []string{
	"us-south",
	"eu-de",
}

func setupOptionsBasicExample(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
	})
	terraformVars := map[string]interface{}{
		"location": validRegions[rand.Intn(len(validRegions))],
	}
	options.TerraformVars = terraformVars
	return options
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "watsonx-data-basic", basicExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptionsBasicExample(t, "watsonx-upg", basicExampleDir)

	output, err := options.RunTestUpgrade()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
