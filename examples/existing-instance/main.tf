########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# Watsonx Data
########################################################################################################################

# module "watsonx_data_crn_parser" {
#   source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
#   version = "1.1.0"
#   crn     = var.existing_watsonx_data_instance_crn
# }

module "existing_watsonx_data_instance" {
  source            = "../../"
  existing_watsonx_data_instance_crn = var.existing_watsonx_data_instance_crn
  resource_group_id = module.resource_group.resource_group_id
}
