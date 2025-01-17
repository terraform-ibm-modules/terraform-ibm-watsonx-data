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

##############################################################################
# Key Protect All Inclusive
##############################################################################

locals {
  enable_kms_policy = var.plan != "lite" ? true : false
  key_ring_name     = "${var.prefix}-keyring"
  key_name          = "${var.prefix}-key"
}

module "key_protect_all_inclusive" {
  count                     = local.enable_kms_policy ? 1 : 0
  source                    = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                   = "4.19.2"
  resource_group_id         = module.resource_group.resource_group_id
  region                    = var.region
  key_protect_instance_name = "${var.prefix}-kp"
  resource_tags             = var.resource_tags
  keys = [
    {
      key_ring_name = "${var.prefix}-keyring"
      keys = [
        {
          key_name     = "${var.prefix}-key"
          force_delete = true
        }
      ]
    }
  ]
}

########################################################################################################################
# Watsonx Data
########################################################################################################################

module "watsonx_data" {
  source                        = "../../"
  region                        = var.region
  watsonx_data_name             = "${var.prefix}-data-instance"
  plan                          = var.plan
  resource_group_id             = module.resource_group.resource_group_id
  use_case                      = "ai"
  resource_tags                 = var.resource_tags
  access_tags                   = var.access_tags
  skip_iam_authorization_policy = local.enable_kms_policy
  watsonx_data_kms_key_crn      = local.enable_kms_policy ? module.key_protect_all_inclusive[0].keys["${local.key_ring_name}.${local.key_name}"].crn : null
}
