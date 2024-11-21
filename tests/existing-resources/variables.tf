########################################################################################################################
# Input variables
########################################################################################################################

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example. If not specified, a new resource group is created."
  default     = null
}

variable "ibmcloud_api_key" {
  type        = string
  sensitive   = true
  description = "The IBM Cloud API Key"
}

variable "region" {
  type        = string
  description = "Region to provision all resources."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources."
}
