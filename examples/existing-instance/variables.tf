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
  description = "Add access management tags to the Watsonx Data instance to control access. [Learn more](https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#create-access-console)."
  default     = []
}
