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
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources."
  default     = "watsonx"
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of the an existing watsonx.data instance."
  default     = null
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "us-south"
}
