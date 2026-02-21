########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.8"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# watsonx.data
########################################################################################################################

module "watsonx_data" {
  source            = "../../"
  region            = var.region
  watsonx_data_name = "${var.prefix}-data-instance"
  plan              = "lakehouse-enterprise"
  resource_group_id = module.resource_group.resource_group_id
  use_case          = "ai"
  resource_tags     = var.resource_tags
  access_tags       = var.access_tags
}
