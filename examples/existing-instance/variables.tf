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

variable "prefix" {
  description = "Prefix to append to all resources."
  type        = string
  default     = "watsonx"
}

variable "existing_watsonx_data_instance_crn" {
  default     = null
  description = "The CRN of the an existing watsonx.data instance."
  type        = string
}

variable "region" {
  default     = "us-south"
  description = "Region to provision all resources created by this example."
  type        = string
}
