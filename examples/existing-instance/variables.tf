########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
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
