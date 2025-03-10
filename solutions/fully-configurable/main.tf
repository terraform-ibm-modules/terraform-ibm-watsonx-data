#######################################################################################################################
# Local block
#######################################################################################################################

locals {
  prefix = var.prefix != null ? (var.prefix != "" ? var.prefix : null) : null

  # fetch KMS region from existing_kms_instance_crn if KMS resources are required and existing_kms_key_crn is not provided
  kms_region        = var.existing_kms_key_crn == null && var.existing_kms_instance_crn != null ? module.existing_kms_crn_parser[0].region : null
  kms_key_ring_name = try("${var.prefix}-${var.kms_key_ring_name}", var.kms_key_ring_name)
  kms_key_name      = try("${var.prefix}-${var.kms_key_name}", var.kms_key_name)

  kms_key_crn = var.enable_kms_encryption ? (var.existing_kms_key_crn != null ? var.existing_kms_key_crn : module.kms[0].keys[format("%s.%s", local.kms_key_ring_name, local.kms_key_name)].crn) : null
}

#######################################################################################################################
# Resource Group
#######################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.1.6"
  existing_resource_group_name = var.existing_resource_group_name
}

#######################################################################################################################
# KMS Key
#######################################################################################################################

# parse KMS details from the existing KMS instance CRN
module "existing_kms_crn_parser" {
  count   = var.existing_kms_instance_crn == null ? 0 : 1
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.1.0"
  crn     = var.existing_kms_instance_crn
}

module "kms" {
  count                       = var.enable_kms_encryption && var.existing_kms_instance_crn != null ? 1 : 0 # no need to create any KMS resources if passing an existing key
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.21.2"
  create_key_protect_instance = false
  region                      = local.kms_region
  existing_kms_instance_crn   = var.existing_kms_instance_crn
  key_ring_endpoint_type      = var.kms_endpoint_type
  key_endpoint_type           = var.kms_endpoint_type
  keys = [
    {
      key_ring_name         = local.kms_key_ring_name
      existing_key_ring     = false
      force_delete_key_ring = true
      keys = [
        {
          key_name                 = local.kms_key_name
          standard_key             = false
          rotation_interval_month  = 3
          dual_auth_delete_enabled = false
          force_delete             = true
        }
      ]
    }
  ]
}

#######################################################################################################################
# watsonx.data with KMS encryption
#######################################################################################################################

module "watsonx_data" {
  source                        = "../../"
  region                        = var.region
  plan                          = var.watsonx_data_plan
  resource_group_id             = module.resource_group.resource_group_id
  watsonx_data_name             = try("${local.prefix}-${var.watsonx_data_instance_name}", var.watsonx_data_instance_name)
  access_tags                   = var.access_tags
  resource_tags                 = var.resource_tags
  use_case                      = var.watsonx_data_plan == "lite" ? var.lite_plan_use_case : null
  enable_kms_encryption         = var.enable_kms_encryption
  skip_iam_authorization_policy = var.skip_watsonx_data_kms_iam_auth_policy
  watsonx_data_kms_key_crn      = local.kms_key_crn
}
