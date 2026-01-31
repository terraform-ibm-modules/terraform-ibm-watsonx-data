#######################################################################################################################
# Local Variables
#######################################################################################################################

locals {
  key_ring_name             = "${var.prefix}-keyring"
  key_name                  = "${var.prefix}-key"
  key_protect_instance_name = "${var.prefix}-kp"
  watsonx_data_name         = "${var.prefix}-data-instance"
  resource_group_name       = "${var.prefix}-resource-group"
}

########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.7"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? local.resource_group_name : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Key Protect All Inclusive
##############################################################################

module "key_protect_all_inclusive" {
  count                     = var.enable_kms_encryption ? 1 : 0
  source                    = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                   = "5.5.27"
  resource_group_id         = module.resource_group.resource_group_id
  region                    = var.region
  key_protect_instance_name = local.key_protect_instance_name
  resource_tags             = var.resource_tags
  keys = [
    {
      key_ring_name = local.key_ring_name
      keys = [
        {
          key_name     = local.key_name
          force_delete = true
        }
      ]
    }
  ]
}

########################################################################################################################
# watsonx.data
########################################################################################################################

module "watsonx_data" {
  source                        = "../../"
  region                        = var.region
  watsonx_data_name             = local.watsonx_data_name
  plan                          = "lakehouse-enterprise"
  resource_group_id             = module.resource_group.resource_group_id
  use_case                      = "workloads"
  resource_tags                 = var.resource_tags
  access_tags                   = var.access_tags
  enable_kms_encryption         = true
  skip_iam_authorization_policy = false
  watsonx_data_kms_key_crn      = module.key_protect_all_inclusive[0].keys["${local.key_ring_name}.${local.key_name}"].crn
}
