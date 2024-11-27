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

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx data instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []
}
