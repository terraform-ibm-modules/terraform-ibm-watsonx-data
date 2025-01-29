########################################################################################################################
# Input variables
########################################################################################################################

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to provision resources into. If not set a new resource group will be created using the prefix variable."
  default     = null
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix for name of all resources created by this example."
  default     = "wx-eg"
  validation {
    error_message = "Prefix must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([A-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to the watsonx.data instance"
  default     = []
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to the created resources."
  default     = []
}

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are: 'lite' and 'lakehouse-enterprise'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)"
  default     = "lakehouse-enterprise"
}
