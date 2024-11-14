########################################################################################################################
# Input Variables
########################################################################################################################

variable "watsonx_data_name" {
  type        = string
  description = "The name of the watsonx.data instance."
}

variable "resource_group_id" {
  description = "The resource group ID where the Event Streams instance is created."
  type        = string
}

variable "location" {
  default     = "us-south"
  description = "The location that's used with the IBM Cloud Terraform IBM provider. It's also used during resource creation."
  type        = string
  validation {
    condition     = contains(["eu-de", "us-south", "eu-gb", "jp-tok"], var.location)
    error_message = "You must specify `eu-de`, `eu-gb`, `jp-tok` or `us-south` as the IBM Cloud location."
  }
}

variable "existing_data_instance" {
  default     = null
  description = "CRN of the an existing watsonx.data instance."
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
    error_message = "You must use a lakehouse-enterprise or lite plan. Learn more. "
  }
}
