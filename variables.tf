########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of the watsonx.data instance."
  default     = null

  validation {
    condition     = ((var.watsonx_data_name != "" && var.resource_group_id != "") || var.existing_watsonx_data_instance_crn != "")
    error_message = "You must specify either 'watsonx_data_name' and 'resource_group_id', or 'existing_watsonx_data_instance_crn'."
  }
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the watsonx data instance is created."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "region" {
  type        = string
  description = "The region to provision the watsonx data instance. "
  default     = "us-south"
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd"], var.region)
    error_message = "You must specify 'eu-de', 'eu-gb', 'jp-tok', 'au-syd' or 'us-south' as the IBM Cloud region."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of the an existing watsonx.data instance. If no value is passed, and new instance will be provisioned."
  default     = null
}

variable "watsonx_data_plan" {
  type        = string
  description = "The plan that's used to provision the watsonx.data instance. Allowed values are 'lite' and 'lakehouse-enterprise'."
  default     = "lite"
  validation {
    condition = anytrue([
      var.watsonx_data_plan == "lakehouse-enterprise",
      var.watsonx_data_plan == "lite",
    ])
    error_message = "You must use a 'lakehouse-enterprise' or 'lite' plan. Learn more https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started"
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx data instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}
