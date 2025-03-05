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
  description = "The name of an existing resource group to provision the watsonx.data in."
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "(Optional) Prefix to add to all resources created by this solution. To not use any prefix value, you can set this value to `null` or an empty string."
}

variable "name" {
  type        = string
  description = "The name of the watsonx.data instance. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "watsonx-data"
}

variable "region" {
  description = "The region where you want to deploy your instance."
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

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are: `lite` , `lakehouse-enterprise` or `lakehouse-enterprise-mcsp` only for `au-syd` region. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started_1)."
  default     = "lakehouse-enterprise"
  validation {
    condition = anytrue([
      var.plan == "lite",
      var.plan == "lakehouse-enterprise" && var.region != "au-syd",     # lakehouse-enterprise is supported in all regions except au-syd
      var.plan == "lakehouse-enterprise-mcsp" && var.region == "au-syd" # lakehouse-enterprise-mcsp is only supported in au-syd
    ])
    error_message = "Allowed plan-region combinations are: 'lite' (any region), 'lakehouse-enterprise' (all regions except 'au-syd'), 'lakehouse-enterprise-mcsp' (only in 'au-syd')."
  }
}

variable "lite_plan_use_case" {
  type        = string
  description = "The lite plan instance can be provisioned based on the three use cases - Generative AI, Data Engineering and High Performance BI. Allowed values are : 'ai', 'workloads' and 'performance'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-tutorial_prov_lite_1)"
  default     = "workloads"

  validation {
    condition     = var.plan == "lite" ? contains(["ai", "workloads", "performance"], var.lite_plan_use_case) : true
    error_message = "Use case is only applicable for the 'Lite' plan. Allowed values are: 'ai', 'workloads', and 'performance'."
  }
}

variable "enable_kms_encryption" {
  description = "Flag to enable KMS encryption. If set to true, a value must be passed for either `existing_kms_instance_crn` or `existing_kms_key_crn`. This is applicable only for Enterprise plan."
  type        = bool
  default     = false

  validation {
    condition     = (var.enable_kms_encryption && var.existing_kms_key_crn == null) ? (var.existing_kms_instance_crn == null ? false : true) : true
    error_message = "A value must be passed for either 'existing_kms_instance_crn' or 'existing_kms_key_crn' when 'enable_kms_encryption' is set to true."
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
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "Valid values for the `kms_endpoint_type` are `public` or `private`."
  }
}

variable "kms_key_ring_name" {
  type        = string
  default     = "watsonx-data-key-ring"
  description = "The name of the key ring to create for the watsonx.data instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key ring is prefixed to the value in the `<prefix>-value` format. This is applicable only for Enterprise plan."
}

variable "kms_key_name" {
  type        = string
  default     = "watsonx-data-key"
  description = "The name of the key to create for the watsonx.data instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key is prefixed to the value in the `<prefix>-value` format. This is applicable only for Enterprise plan."
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to create an IAM authorization policy that permits the watsonx.data instance to read the encryption key from the KMS instance.  Set to `true` to avoid creating the policy."
  default     = false
}
