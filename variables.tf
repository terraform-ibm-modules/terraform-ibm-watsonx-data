########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of the watsonx.data instance."
  default     = "watsonx-data"
}

variable "resource_group_id" {
  description = "The resource group ID where the watsonx data instance is created."
  type        = string
}

variable "region" {
  default     = "us-south"
  description = "The region that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd"], var.region)
    error_message = "You must specify 'eu-de', 'eu-gb', 'jp-tok', 'au-syd' or 'us-south' as the IBM Cloud region."
  }
}

variable "existing_watsonx_data_instance_crn" {
  default     = null
  description = "The CRN of the an existing watsonx.data instance. If no value is passed, and new instance will be provisioned"
  type        = string
}

variable "watsonx_data_plan" {
  default     = "do not install"
  description = "The plan that's used to provision the watsonx.data instance."
  type        = string
  validation {
    condition = anytrue([
      var.watsonx_data_plan == "do not install",
      var.watsonx_data_plan == "lakehouse-enterprise",
      var.watsonx_data_plan == "lite",
    ])
    error_message = "You must use a 'do not install', 'lakehouse-enterprise' or 'lite' plan. Learn more. "
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the Key Protect instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}
