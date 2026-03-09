# Advanced example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=watsonx-data-advanced-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-data/tree/main/examples/advanced">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

This example provisions an instance of the [watsonx.data](https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-data)

Following resources are provisioned by this example:

- A new resource group if an existing one is not passed in.
- A newly created IBM watsonx.data instance, with KMS encryption enabled
