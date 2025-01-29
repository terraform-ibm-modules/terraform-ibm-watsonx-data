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

variable "use_existing_resource_group" {
  type        = bool
  description = "Whether to use an existing resource group."
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or an existing resource group to provision the watsonx.data in. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
}

variable "prefix" {
  type        = string
  description = "(Optional) Prefix to add to all resources created by this solution. To not use any prefix value, you can set this value to `null` or an empty string."
  default     = "data-dev"
}

variable "name" {
  type        = string
  description = "The name of the watsonx.data instance. If a prefix input variable is specified, the prefix is added to the name in the `<prefix>-<name>` format."
  default     = "dev"
}

variable "region" {
  description = "The region where you want to deploy your instance."
  type        = string
  default     = "us-south"
  validation {
    condition     = local.kms_region == null || (local.kms_region == var.region)
    error_message = "In case of enterprise plan, KMS instance should be in the same region as watsonx.data"
  }
}

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are: essentials, standard. [Learn more](https://www.ibm.com/products/watsonx-data/pricing)."
  default     = "lakehouse-enterprise"
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

variable "enable_kms_encryption" {
  description = "Flag to enable KMS encryption. If set to true, a value must be passed for `existing_kms_key_crn`. This is applicable only for Enterprise plan."
  type        = bool
  default     = true

  validation {
    condition     = (var.enable_kms_encryption && var.existing_kms_key_crn == null) ? (var.existing_kms_instance_crn == null ? false : true) : true
    error_message = "A value must be passed for either 'existing_kms_instance_crn' or 'existing_kms_key_crn' when 'enable_kms_encryption' is set to true."
  }
}


variable "existing_kms_instance_crn" {
  type        = string
  default     = null
  description = "The CRN of the existing key management service (KMS) that is used to create keys for encrypting the watsonx.data enterprise instance. If you are not using an existing KMS root key, you must specify this CRN. If you are using an existing KMS root key, an existing watsonx.data instance and auth policy is not set for watsonx.data to KMS, you must specify this CRN."

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
  description = "(Optional) CRN of an existing key management service (Key Protect) key to use to encrypt the watsonx.data enterprise instance that this solution creates. To create a key ring and key, pass a value for the `existing_kms_instance_crn` input variable."
}

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to use for communicating with the Key Protect instance. Possible values: `public`, `private`. Applies only if `existing_kms_key_crn` is not specified. This is applicable only for Enterprise plan."
  default     = "public"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "Valid values for the `kms_endpoint_type` are `public` or `private`."
  }
}

variable "kms_key_ring_name" {
  type        = string
  default     = "watsonx-data-key-ring"
  description = "The name of the key ring to create for the watsonx.data enterprise instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key ring is prefixed to the value in the `<prefix>-value` format."
}

variable "kms_key_name" {
  type        = string
  default     = "watsonx-data-key"
  description = "The name of the key to create for the watsonx.data enterprise instance. If an existing key is used, this variable is not required. If the prefix input variable is passed, the name of the key is prefixed to the value in the `<prefix>-value` format."
}
