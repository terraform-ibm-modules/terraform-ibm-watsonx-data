# Terraform IBM Watsonx Data

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-watsonx-data?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-watsonx-data/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!--
Add a description of modules in this repo.
Expand on the repo short description in the .github/settings.yml file.

For information, see "Module names and descriptions" at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=module-names-and-descriptions
-->

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-watsonx-data](#terraform-ibm-watsonx-data)
* [Examples](./examples)
    * [Basic example](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!--
If this repo contains any reference architectures, uncomment the heading below and link to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
<!-- ## Reference architectures -->


<!-- Replace this heading with the name of the root level module (the repo name) -->
## terraform-ibm-watsonx-data

This module supports provisioning the following:

* Provisioning watsonx.data instance with a selectable service plan

### Usage

```hcl
module "watsonx_data" {
    source = "terraform-ibm-modules/watsonx-data/ibm"
    version = "X.Y.Z" # Replace "X.X.X" with a release version to lock into a specific release
    resource
    resource_prefix = "watsonx-poc"
    service = "lakehouse"
    location = "us-south"
    plan = "lite"
    resource_group_id     = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
}

```

### Required access policies

You need the following permissions to run this module.

- Editor platform role on watsonx.data if you must provision.
<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.70.1, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_resource_instance.data_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_instance.existing_data_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_instance) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_existing_data_instance"></a> [existing\_data\_instance](#input\_existing\_data\_instance) | CRN of the an existing watsonx.data instance. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the Event Streams instance is created. | `string` | n/a | yes |
| <a name="input_watsonx_data_name"></a> [watsonx\_data\_name](#input\_watsonx\_data\_name) | The name of the watsonx.data instance. | `string` | n/a | yes |
| <a name="input_watsonx_data_plan"></a> [watsonx\_data\_plan](#input\_watsonx\_data\_plan) | The plan that's used to provision the watsonx.data instance. | `string` | `"do not install"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_watsonx_data_crn"></a> [watsonx\_data\_crn](#output\_watsonx\_data\_crn) | The CRN of the watsonx.data instance. |
| <a name="output_watsonx_data_dashboard_url"></a> [watsonx\_data\_dashboard\_url](#output\_watsonx\_data\_dashboard\_url) | The dashboard URL of the watsonx.data instance. |
| <a name="output_watsonx_data_guid"></a> [watsonx\_data\_guid](#output\_watsonx\_data\_guid) | The GUID of the watsonx.data instance. |
| <a name="output_watsonx_data_name"></a> [watsonx\_data\_name](#output\_watsonx\_data\_name) | The name of the watsonx.data instance. |
| <a name="output_watsonx_data_plan_id"></a> [watsonx\_data\_plan\_id](#output\_watsonx\_data\_plan\_id) | The plan ID of the watsonx.data instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
