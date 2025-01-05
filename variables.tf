########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of the watsonx.data instance. Required if creating a new instance."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.watsonx_data_name) > 0 : true
    error_message = "watsonx.data name must be provided when creating a new instance."
  }
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the watsonx.data instance will be grouped. Required when creating a new instance."
  default     = null

  validation {
    condition     = var.existing_watsonx_data_instance_crn == null ? length(var.resource_group_id) > 0 : true
    error_message = "You must specify a value for 'resource_group_id' if 'existing_watsonx_data_instance_crn' is null."
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to describe the watsonx.data instance created by the module."
  default     = []
}

variable "region" {
  type        = string
  description = "The region to provision the watsonx.data instance."
  default     = "us-south"
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok", "au-syd"], var.region)
    error_message = "You must specify 'eu-de', 'eu-gb', 'jp-tok', 'au-syd' or 'us-south' as the IBM Cloud region."
  }
}

variable "existing_watsonx_data_instance_crn" {
  type        = string
  description = "The CRN of an existing watsonx.data instance.If not provided, a new instance will be provisioned."
  default     = null
}

variable "plan" {
  type        = string
  description = "The plan that is required to provision the watsonx.data instance. Possible values are: 'lite' and 'lakehouse-enterprise'. [Learn more](https://cloud.ibm.com/docs/watsonxdata?topic=watsonxdata-getting-started)"
  default     = "lite"
  validation {
    condition = anytrue([
      var.plan == "lakehouse-enterprise",
      var.plan == "lite",
    ])
    error_message = "A new watsonx.data instance requires a 'lakehouse-enterprise' or 'lite' plan."
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the watsonx.data instance created by the module. For more information, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial."
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}
