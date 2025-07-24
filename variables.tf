########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of the watsonx.data instance. Required if creating a new instance."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.watsonx_data_name) > 0 : true
    error_message = "watsonx.data name must be provided when creating a new instance."
  }
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the watsonx.data instance will be grouped. Required when creating a new instance."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.resource_group_id) > 0 : true
    error_message = "You must specify a value for 'resource_group_id' if 'existing_watsonx_data_instance_crn' is null."
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to describe the watsonx.data instance created by the module."
  default     = []
}

variable "region" {
  type        = string
  description = "The region to provision the watsonx.data instance."
  default     = "eu-de"
  validation {
    condition     = contains(["eu-de", "eu-gb", "jp-tok", "us-south", "us-east", "au-syd", "ca-tor"], var.region)
    error_message = "You must specify one of the supported IBM Cloud regions: eu-de, eu-gb, jp-tok, us-south, us-east, au-syd, or ca-tor."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of an existing watsonx.data instance.If not provided, a new instance will be provisioned."
  default     = null
}

variable "plan" {
  type        = string
  description = "The plan required to provision the watsonx.data instance. Possible values are: 'Lite' and 'Enterprise'. The 'Lite' plan is available in the `eu-de`, `jp-tok`, and `eu-gb` regions. The 'Enterprise' plan is available in the `eu-de`, `us-east`, `us-south`, `jp-tok`, `eu-gb`, `au-syd`, and `ca-tor` regions. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)"
  default     = "lite"
  validation {
    condition = anytrue([
      var.plan == "lite" && contains(["eu-de", "eu-gb", "jp-tok"], var.region),
      var.plan == "lakehouse-enterprise" && contains(["us-south", "eu-de", "eu-gb", "jp-tok", "us-east", "au-syd", "ca-tor"], var.region)
    ])
    error_message = "Allowed plan-region combinations are: 'lite' (eu-de, eu-gb, jp-tok), 'lakehouse-enterprise' (eu-de, eu-gb, jp-tok, us-south, us-east), 'lakehouse-enterprise-mcsp' (only in au-syd, ca-tor)."
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx.data instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}

variable "use_case" {
  type        = string
  description = "The Lite plan instance can be provisioned based on the three use cases - Generative AI, Data Engineering and High Performance BI. Allowed values are : 'ai', 'workloads' and 'performance'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-tutorial_prov_lite_1)"
  default     = "workloads"

  validation {
    condition     = var.plan == "lite" ? contains(["ai", "workloads", "performance"], var.use_case) : true
    error_message = "Use case is only applicable for the 'Lite' plan. Allowed values are: 'ai', 'workloads', and 'performance'."
  }
}

variable "enable_kms_encryption" {
  description = "Flag to enable the KMS encryption when the configured plan is 'Enterprise (lakehouse-enterprise)' and the deployment region is not 'au-syd' and 'cat-tor'."
  type        = bool
  default     = false
  validation {
    condition     = !var.enable_kms_encryption || local.enterprise_plan_type == "lakehouse-enterprise"
    error_message = "KMS encryption is supported only when the configured plan is 'Enterprise (lakehouse-enterprise)' and the deployment region is not 'au-syd' and 'cat-tor'."
  }
}

variable "watsonx_data_kms_key_crn" {
  description = "The KMS key CRN used to encrypt the watsonx.data instance."
  type        = string
  default     = null
  validation {
    condition     = local.enterprise_plan_type == "lakehouse-enterprise" || var.watsonx_data_kms_key_crn == null
    error_message = "The 'watsonx_data_kms_key_crn' variable is only applicable when the plan configured is 'lakehouse-enterprise' and the deployment region is not 'au-syd' and 'cat-tor'.."
  }
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance.  Set to `true` to avoid creating the policy."
  default     = false
}
