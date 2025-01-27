# IBM Watsonx.data

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
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
IBM® watsonx.data is a new open architecture lakehouse that combines the elements of the data warehouse and data lakes. For more information visit [here](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-wxd_ov)
<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-watsonx-data](#terraform-ibm-watsonx-data)
* [Examples](./examples)
    * [Basic example](./examples/basic)
    * [Existing instance example](./examples/existing-instance)
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
    source                = "terraform-ibm-modules/watsonx-data/ibm"
    version               = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
    watsonx_data_name     = "watsonx-data"
    region                = "us-south"
    watsonx_data_plan     = "lite"
    resource_group_id     = "xxXXxxXXxXxxXXXXX" # replace with ID of resource group
}

```

### Required access policies

You need the following permissions to run this module.

* Account Management
  * **Resource Group**
        - `Viewer` role
* IAM Services
  * **watsonx.data** service
        - `Editor` platform access

To attach access management tags to resources in this module, you need the following permissions.

- IAM Services
    - **Tagging** service
        - `Administrator` platform access

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.70.1, < 2.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.12.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_crn_parser"></a> [crn\_parser](#module\_crn\_parser) | terraform-ibm-modules/common-utilities/ibm//modules/crn-parser | 1.1.0 |
| <a name="module_kms_key_crn_parser"></a> [kms\_key\_crn\_parser](#module\_kms\_key\_crn\_parser) | terraform-ibm-modules/common-utilities/ibm//modules/crn-parser | 1.1.0 |

### Resources

| Name | Type |
|------|------|
| [ibm_iam_authorization_policy.kms_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_resource_instance.data_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_tag.watsonx_data_tag](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_tag) | resource |
| [time_sleep.wait_for_kms_authorization_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_resource_instance.existing_data_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_instance) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the watsonx.data instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial. | `list(string)` | `[]` | no |
| <a name="input_enable_kms_encryption"></a> [enable\_kms\_encryption](#input\_enable\_kms\_encryption) | Flag to enable the KMS encryption. | `bool` | `false` | no |
| <a name="input_existing_watsonx_data_instance_crn"></a> [existing\_watsonx\_data\_instance\_crn](#input\_existing\_watsonx\_data\_instance\_crn) | The CRN of an existing watsonx.data instance.If not provided, a new instance will be provisioned. | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The plan that is required to provision the watsonx.data instance. Possible values are: 'lite' and 'lakehouse-enterprise'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started) | `string` | `"lite"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to provision the watsonx.data instance. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the watsonx.data instance will be grouped. Required when creating a new instance. | `string` | `null` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to describe the watsonx.data instance created by the module. | `list(string)` | `[]` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance.  Set to `true` to avoid creating the policy. | `bool` | `false` | no |
| <a name="input_use_case"></a> [use\_case](#input\_use\_case) | The Lite plan instance can be provisioned based on the three use cases - Generative AI, Data Engineering and High Performance BI. Allowed values are : 'ai', 'workloads' and 'performance'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-tutorial_prov_lite_1) | `string` | `"workloads"` | no |
| <a name="input_watsonx_data_kms_key_crn"></a> [watsonx\_data\_kms\_key\_crn](#input\_watsonx\_data\_kms\_key\_crn) | The KMS key CRN used to encrypt the watsonx.data instance. | `string` | `null` | no |
| <a name="input_watsonx_data_name"></a> [watsonx\_data\_name](#input\_watsonx\_data\_name) | The name of the watsonx.data instance. Required if creating a new instance. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | Account ID of the watsonx.data instance. |
| <a name="output_crn"></a> [crn](#output\_crn) | The CRN of the watsonx.data instance. |
| <a name="output_dashboard_url"></a> [dashboard\_url](#output\_dashboard\_url) | The dashboard URL of the watsonx.data instance. |
| <a name="output_guid"></a> [guid](#output\_guid) | The GUID of the watsonx.data instance. |
| <a name="output_id"></a> [id](#output\_id) | ID of the watsonx.data instance. |
| <a name="output_name"></a> [name](#output\_name) | The name of the watsonx.data instance. |
| <a name="output_plan_id"></a> [plan\_id](#output\_plan\_id) | The plan ID of the watsonx.data instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
