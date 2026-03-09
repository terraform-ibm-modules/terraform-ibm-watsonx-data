########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of your watsonx.data instance. Required to create an instance of watsonx.data."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.watsonx_data_name) > 0 : true
    error_message = "watsonx.data name must be provided when an instance is created."
  }
}

variable "resource_group_id" {
  type        = string
  description = "The ID of the resource group that contains the watsonx.data instance. Required to create an instance of watsonx.data."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.resource_group_id) > 0 : true
    error_message = "You must specify a value for `resource_group_id` if `existing_watsonx_data_instance_crn` is set to `null`."
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to describe the watsonx.data instance created by the module."
  default     = []
}

variable "region" {
  type        = string
  description = "Region where the watsonx.data instance is provisioned."
  default     = "eu-de"
  validation {
    condition     = contains(["eu-de", "eu-gb", "jp-tok", "us-south", "us-east", "au-syd", "ca-tor"], var.region)
    error_message = "You must specify one of the supported IBM Cloud regions: eu-de, eu-gb, jp-tok, us-south, us-east, au-syd, or ca-tor."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of an existing watsonx.data instance. If not provided, a new instance is provisioned."
  default     = null
}

variable "plan" {
  type        = string
  description = "The plan required to provision the watsonx.data instance. Possible values are: `lite`, `lakehouse-enterprise` and `lakehouse-enterprise-mcsp`. The `lite` plan is available in the `eu-de`, `jp-tok` and `us-south`. The `lakehouse-enterprise` plan is available in the `eu-de`, `eu-gb`, `jp-tok`, `us-east` and `us-south` regions. The `lakehouse-enterprise-mcsp` plan is available in `au-syd` and `ca-tor`. [Learn more](https://cloud.ibm.com/watsonxdata)"
  default     = "lite"

  validation {
    condition = anytrue([
      var.plan == "lite" && contains(["eu-de", "jp-tok", "us-south"], var.region),
      var.plan == "lakehouse-enterprise" && contains(["eu-de", "eu-gb", "jp-tok", "us-east", "us-south"], var.region),
      var.plan == "lakehouse-enterprise-mcsp" && contains(["au-syd", "ca-tor"], var.region)
    ])
    error_message = "Possible plan and region combinations are: `lite` (eu-de, jp-tok, us-south), `lakehouse-enterprise` (eu-de, eu-gb, jp-tok, us-east, us-south), `lakehouse-enterprise-mcsp` (only in au-syd, ca-tor)."
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx.data instance created by the module. [Learn more](https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial)."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression `\"[\\w\\-_\\.]+:[\\w\\-_\\.]+\"`, see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}

variable "use_case" {
  type        = string
  description = "The Lite plan instance can be provisioned based on the three use cases - Generative AI, Data Engineering and High Performance BI. Allowed values are `ai`, `workloads`, and `performance`. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-tutorial_prov_lite_1)."
  default     = "workloads"

  validation {
    condition     = var.plan == "lite" ? contains(["ai", "workloads", "performance"], var.use_case) : true
    error_message = "Use case is only applicable for the `Lite` plan. Possible values are `ai`, `workloads`, and `performance`."
  }
}

variable "enable_kms_encryption" {
  description = "Flag to enable key management service encryption when the configured plan is 'Enterprise (lakehouse-enterprise)' and the deployment region is not 'au-syd' and 'ca-tor'."
  type        = bool
  default     = false
}

variable "watsonx_data_kms_key_crn" {
  description = "The CRN of the key management service key used to encrypt the watsonx.data instance."
  type        = string
  default     = null
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the key management service instance. Set to `true` to avoid creating the policy."
  default     = false
}
