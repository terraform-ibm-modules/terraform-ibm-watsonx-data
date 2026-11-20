// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the tests in pr_test.go
package test

import (
	"testing"

	"github.com/IBM/go-sdk-core/v5/core"
	"github.com/stretchr/testify/require"

	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testaddons"
)

func TestWatsonxDataDefaultConfiguration(t *testing.T) {
	t.Parallel()

	options := testaddons.TestAddonsOptionsDefault(&testaddons.TestAddonOptions{
		Testing:               t,
		Prefix:                "data-def",
		ResourceGroup:         resourceGroup,
		OverrideInputMappings: core.BoolPtr(true),
		QuietMode:             false, // Suppress logs except on failure
	})

	options.AddonConfig = cloudinfo.NewAddonConfigTerraform(
		options.Prefix,
		"deploy-arch-ibm-watsonx-data",
		"fully-configurable",
		map[string]interface{}{
			"existing_resource_group_name": resourceGroup,
		},
	)
	// Disable target / route creation to prevent hitting quota in account
	options.AddonConfig.Dependencies = []cloudinfo.AddonConfig{
		{
			OfferingName:   "deploy-arch-ibm-cloud-monitoring",
			OfferingFlavor: "fully-configurable",
			Inputs: map[string]interface{}{
				"enable_metrics_routing_to_cloud_monitoring": false,
			},
			Enabled: core.BoolPtr(true),
		},
		{
			OfferingName:   "deploy-arch-ibm-activity-tracker",
			OfferingFlavor: "fully-configurable",
			Inputs: map[string]interface{}{
				"enable_activity_tracker_event_routing_to_cloud_logs": false,
			},
			Enabled: core.BoolPtr(true),
		},
		{
			OfferingName:   "deploy-arch-ibm-scc-workload-protection",
			OfferingFlavor: "fully-configurable",
			Inputs: map[string]interface{}{
				"app_config_crn": permanentResources["app_config_crn"],
			},
			Enabled: core.BoolPtr(true),
		},
		{
			OfferingName:   "deploy-arch-ibm-apprapp",
			OfferingFlavor: "fully-configurable",
			Enabled:        core.BoolPtr(false),
		},
	}

	err := options.RunAddonTest()
	require.NoError(t, err)
}
