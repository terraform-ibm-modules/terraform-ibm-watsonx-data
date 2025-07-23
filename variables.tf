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
  default     = "us-south"
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd"], var.region)
    error_message = "You must specify 'eu-de', 'eu-gb', 'jp-tok', 'au-syd', or 'us-south' as the IBM Cloud region."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of an existing watsonx.data instance. If not provided, a new instance is provisioned."
  default     = null
}

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are `lite` , `lakehouse-enterprise`, and `lakehouse-enterprise-mcsp` (only for `au-syd` region). [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)."
  default     = "lite"

  validation {
    condition = anytrue([
      var.plan == "lite",
      var.plan == "lakehouse-enterprise" && var.region != "au-syd",     # lakehouse-enterprise is supported in all regions except au-syd
      var.plan == "lakehouse-enterprise-mcsp" && var.region == "au-syd" # lakehouse-enterprise-mcsp is only supported in au-syd
    ])
    error_message = "Possible plan and region combinations are `lite` (any region), `lakehouse-enterprise` (all regions except `au-syd`), `lakehouse-enterprise-mcsp` (only in `au-syd`)."
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
  description = "Flag to enable KMS encryption."
  type        = bool
  default     = false
  validation {
    condition     = !var.enable_kms_encryption || var.plan == "lakehouse-enterprise"
    error_message = "KMS encryption is only supported with the `lakehouse-enterprise` plan."
  }
}

variable "watsonx_data_kms_key_crn" {
  description = "The CRN of the KMS key used to encrypt the watsonx.data instance."
  type        = string
  default     = null
  validation {
    condition     = var.plan == "lakehouse-enterprise" || var.watsonx_data_kms_key_crn == null
    error_message = "The `watsonx_data_kms_key_crn` variable is only supported with the `lakehouse-enterprise` plan."
  }
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance. Set to `true` to avoid creating the policy."
  default     = false
}
