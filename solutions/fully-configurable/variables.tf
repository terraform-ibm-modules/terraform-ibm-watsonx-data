##############################################################################
# Input Variables
##############################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key to deploy resources."
  sensitive   = true
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the resources. [Learn more](https://cloud.ibm.com/docs/account?topic=account-rgs&interface=ui#create_rgs) about how to create a resource group."
  default     = "Default"
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to add to all resources that this solution creates (e.g `prod`, `test`, `dev`). To skip using a prefix, set this value to null or an empty string. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    condition = var.prefix == null || var.prefix == "" ? true : alltrue([
      can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)), length(regexall("--", var.prefix)) == 0
    ])
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    condition     = var.prefix == null || var.prefix == "" ? true : length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}

variable "watsonx_data_instance_name" {
  type        = string
  description = "The name of the watsonx.data instance. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "watsonx-data"
}

variable "region" {
  description = "The region to provision all resources in. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/region) about how to select different regions for different services."
  type        = string
  default     = "us-south"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to describe the newly created watsonx.data instance."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx.data instance. [Learn more](https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial)."
  default     = []
}

variable "service_plan" {
  type        = string
  description = "The plan required to provision the watsonx.data instance.[Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)"
  default     = "lakehouse-enterprise"
}

variable "lite_plan_use_case" {
  type        = string
  description = "The lite plan instance can be provisioned based on the three use cases - Generative AI, Data Engineering and High Performance BI. Allowed values are : 'ai', 'workloads' and 'performance'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-tutorial_prov_lite_1)"
  default     = "workloads"

  validation {
    condition     = var.service_plan == "lite" ? contains(["ai", "workloads", "performance"], var.lite_plan_use_case) : true
    error_message = "Use case is only applicable for the 'Lite' plan. Allowed values are: 'ai', 'workloads', and 'performance'."
  }
}

variable "enable_kms_encryption" {
  description = "Flag to enable KMS encryption. If set to true, a value must be passed for either `existing_kms_instance_crn` or `existing_kms_key_crn`. This is applicable only for Enterprise plan."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_kms_encryption ? (var.existing_kms_instance_crn != null || var.existing_kms_key_crn != null) : true
    error_message = "When 'enable_kms_encryption' is true, you must provide either 'existing_kms_instance_crn' or 'existing_kms_key_crn'."
  }

  validation {
    condition     = var.enable_kms_encryption ? !(var.existing_kms_instance_crn != null && var.existing_kms_key_crn != null) : true
    error_message = "When 'enable_kms_encryption' is true, you cannot provide both 'existing_kms_instance_crn' and 'existing_kms_key_crn'. Choose only one."
  }

  validation {
    condition     = !var.enable_kms_encryption ? (var.existing_kms_instance_crn == null && var.existing_kms_key_crn == null) : true
    error_message = "When 'enable_kms_encryption' is false, you cannot specify 'existing_kms_instance_crn' or 'existing_kms_key_crn'."
  }
}

variable "existing_kms_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of the existing key management service (KMS) that is used to create keys for encrypting the watsonx.data instance. If you are not using an existing KMS root key, you must specify this CRN. If you are using an existing KMS root key and auth policy is not set for watsonx.data to KMS, you must specify this CRN. This is applicable only for Enterprise plan."

  validation {
    condition = anytrue([
      can(regex("^crn:(.*:){3}kms:(.*:){2}[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}::$", var.existing_kms_instance_crn)),
      var.existing_kms_instance_crn == null,
    ])
    error_message = "The provided KMS (Key Protect) instance CRN in not valid."
  }
}

variable "existing_kms_key_crn" {
  type        = string
  default     = null
  description = "(Optional) CRN of an existing key management service (Key Protect) key to use to encrypt the watsonx.data instance that this solution creates. To create a key ring and key, pass a value for the `existing_kms_instance_crn` input variable. This is applicable only for Enterprise plan."
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to use for communicating with the Key Protect instance. Possible values: `public`, `private`. Applies only if `existing_kms_key_crn` is specified. This is applicable only for Enterprise plan."
  default     = "private"
  validation {
    condition     = can(regex("^(public|private)$", var.kms_endpoint_type))
    error_message = "Valid values for the `kms_endpoint_type` are `public` or `private`."
  }
}

variable "watsonx_data_key_ring_name" {
  type        = string
  default     = "watsonx-data-key-ring"
  description = "The name of the key ring to create for the watsonx.data instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key ring is prefixed to the value in the `<prefix>-value` format. This is applicable only for Enterprise plan."
}

variable "watsonx_data_key_name" {
  type        = string
  default     = "watsonx-data-key"
  description = "The name of the key to create for the watsonx.data instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key is prefixed to the value in the `<prefix>-value` format. This is applicable only for Enterprise plan."
}

variable "skip_watsonx_data_kms_iam_auth_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance.  Set to `true` to avoid creating the policy."
  default     = false
}
