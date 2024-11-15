########################################################################################################################
# Input variables
########################################################################################################################

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example. If not specified, a new resource group is created."
  default     = null
}

variable "ibmcloud_api_key" {
  description = "Used with the Terraform IBM-Cloud/ibm provider"
  sensitive   = true
  type        = string
}

variable "region" {
  default     = "us-south"
  description = "Used with the Terraform IBM-Cloud/ibm provider as well as resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "eu-gb", "jp-tok", "us-south"], var.region)
    error_message = "The IBM Cloud region to use must be one of: eu-de, eu-gb, jp-tok or us-south"
  }
}

variable "prefix" {
  description = "The name to be used on all Watson resources as a prefix."
  type        = string
  default     = "watsonx"

  validation {
    condition     = var.prefix != "" && length(var.prefix) <= 25
    error_message = "You must provide a value for the prefix variable and the prefix length can't exceed 25 characters."
  }
}
