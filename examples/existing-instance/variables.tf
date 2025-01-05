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
  description = "The CRN of an existing watsonx.data instance."
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to the watsonx.data instance"
  default     = []
}
