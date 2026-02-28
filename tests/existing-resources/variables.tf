########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "The name of an existing resource group to provision resources into. If not set a new resource group will be created using the prefix variable."
  default     = null
}

variable "region" {
  type        = string
  description = "Region to provision all resources."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix for name of all resources created by this example"
  default     = "tst-data"
  validation {
    error_message = "Prefix must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([A-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Add user resource tags to the Watsonx Data instance to organize, track, and manage costs. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#tag-types)."
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Add access management tags to the Watsonx Data instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#create-access-console)."
  default     = []
}
