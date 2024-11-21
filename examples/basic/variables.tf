########################################################################################################################
# Input variables
########################################################################################################################

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example. If not specified, a new resource group is created."
  default     = null
}

variable "ibmcloud_api_key" {
  description = "The IBM Cloud API Key"
  sensitive   = true
  type        = string
}

variable "region" {
  default     = "us-south"
  description = "Region to provision all resources created by this example."
  type        = string
}

variable "prefix" {
  description = "The name to be used on all Watson resources as a prefix."
  type        = string
  default     = "watsonx"
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to the Key Protect instance"
  default     = []
}
