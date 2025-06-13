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
  default     = "us-south"
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd", "ca-tor"], var.region)
    error_message = "You must specify 'eu-de', 'eu-gb', 'jp-tok', 'au-syd' or 'us-south' as the IBM Cloud region."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of an existing watsonx.data instance.If not provided, a new instance will be provisioned."
  default     = null
}

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are: 'lite', 'lakehouse-enterprise' and 'lakehouse-enterprise-mcsp'. 'lite' and 'lakehouse-enterprise' are available only in eu-de, us-east, us-south, jp-tok, and eu-gb. 'lakehouse-enterprise-mcsp' is available only in au-syd and ca-tor. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)"
  default     = "lite"
  validation {
    condition = anytrue([
      var.plan == "lite" && contains(["eu-de", "us-east", "us-south", "jp-tok", "eu-gb"], var.region),
      var.plan == "lakehouse-enterprise" && contains(["eu-de", "us-east", "us-south", "jp-tok", "eu-gb"], var.region),
      var.plan == "lakehouse-enterprise-mcsp" && contains(["au-syd", "ca-tor"], var.region)
    ])
    error_message = "Allowed plan-region combinations are: 'lite' and 'lakehouse-enterprise' (eu-de, us-east, us-south, jp-tok, eu-gb), 'lakehouse-enterprise-mcsp' (only in au-syd, ca-tor)."
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
  description = "Flag to enable the KMS encryption."
  type        = bool
  default     = false
  validation {
    condition     = !var.enable_kms_encryption || var.plan == "lakehouse-enterprise"
    error_message = "KMS encryption is only supported when the plan configured is 'lakehouse-enterprise'."
  }
}

variable "watsonx_data_kms_key_crn" {
  description = "The KMS key CRN used to encrypt the watsonx.data instance."
  type        = string
  default     = null
  validation {
    condition     = var.plan == "lakehouse-enterprise" || var.watsonx_data_kms_key_crn == null
    error_message = "The 'watsonx_data_kms_key_crn' variable is only applicable when the plan configured is 'lakehouse-enterprise'."
  }
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance.  Set to `true` to avoid creating the policy."
  default     = false
}
