#######################################################################################################################
# Resource Group
#######################################################################################################################

module "resource_group" {
  source                       = "terraform-ibm-modules/resource-group/ibm"
  version                      = "1.6.0"
  existing_resource_group_name = var.existing_resource_group_name
}

# Lookup account ID
data "ibm_iam_account_settings" "iam_account_settings" {
}
#######################################################################################################################
# Local block
#######################################################################################################################

locals {
  prefix     = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""
  account_id = data.ibm_iam_account_settings.iam_account_settings.account_id

  kms_key_ring_name = var.watsonx_data_key_ring_name != null ? "${local.prefix}${var.watsonx_data_key_ring_name}" : null
  kms_key_name      = var.watsonx_data_key_name != null ? "${local.prefix}${var.watsonx_data_key_name}" : null

  existing_kms_instance_guid = var.enable_kms_encryption ? var.existing_kms_instance_crn != null ? module.existing_kms_crn_parser[0].service_instance : var.existing_kms_key_crn != null ? module.kms_key_crn_parser[0].service_instance : null : null
  # fetch KMS region from existing_kms_instance_crn if KMS resources are required and existing_kms_key_crn is not provided
  kms_region                       = var.enable_kms_encryption ? var.existing_kms_instance_crn != null ? module.existing_kms_crn_parser[0].region : var.existing_kms_key_crn != null ? module.kms_key_crn_parser[0].region : null : null
  kms_service_name                 = var.enable_kms_encryption ? var.existing_kms_instance_crn != null ? module.existing_kms_crn_parser[0].service_name : var.existing_kms_key_crn != null ? module.kms_key_crn_parser[0].service_name : null : null
  kms_account_id                   = var.enable_kms_encryption ? var.existing_kms_instance_crn != null ? module.existing_kms_crn_parser[0].account_id : var.existing_kms_key_crn != null ? module.kms_key_crn_parser[0].account_id : null : null
  kms_key_crn                      = var.enable_kms_encryption ? (var.existing_kms_key_crn != null ? var.existing_kms_key_crn : module.kms[0].keys[format("%s.%s", local.kms_key_ring_name, local.kms_key_name)].crn) : null
  kms_key_id                       = var.enable_kms_encryption ? var.existing_kms_key_crn != null ? module.kms_key_crn_parser[0].resource : module.kms[0].keys[format("%s.%s", local.kms_key_ring_name, local.kms_key_name)].key_id : null
  create_cross_account_auth_policy = !var.skip_watsonx_data_kms_iam_auth_policy && var.ibmcloud_kms_api_key != null
}

#######################################################################################################################
# KMS Key
#######################################################################################################################

# parse KMS details from the existing KMS instance CRN
module "existing_kms_crn_parser" {
  count   = var.existing_kms_instance_crn == null ? 0 : 1
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.5.0"
  crn     = var.existing_kms_instance_crn
}

module "kms_key_crn_parser" {
  count   = var.existing_kms_key_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.5.0"
  crn     = var.existing_kms_key_crn
}

resource "ibm_iam_authorization_policy" "watsonx_data_kms_policy" {
  count                    = local.create_cross_account_auth_policy ? 1 : 0
  provider                 = ibm.kms
  source_service_account   = local.account_id
  source_service_name      = "lakehouse"
  source_resource_group_id = module.resource_group.resource_group_id
  roles                    = ["Reader"]
  description              = "Allow the watsonx.data instances in the resource group ${module.resource_group.resource_group_id} in the account ${local.account_id} to read the ${local.kms_service_name} key ${local.kms_key_id} from the instance ${local.existing_kms_instance_guid}"
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = local.kms_service_name
  }
  resource_attributes {
    name     = "accountId"
    operator = "stringEquals"
    value    = local.kms_account_id
  }
  resource_attributes {
    name     = "serviceInstance"
    operator = "stringEquals"
    value    = local.existing_kms_instance_guid
  }
  resource_attributes {
    name     = "resourceType"
    operator = "stringEquals"
    value    = "key"
  }
  resource_attributes {
    name     = "resource"
    operator = "stringEquals"
    value    = local.kms_key_id
  }
  # Scope of policy now includes the key, so ensure to create new policy before
  # destroying old one to prevent any disruption to every day services.
  lifecycle {
    create_before_destroy = true
  }
}

resource "time_sleep" "wait_for_authorization_policy" {
  depends_on      = [ibm_iam_authorization_policy.watsonx_data_kms_policy]
  create_duration = "30s"
}

module "kms" {
  providers = {
    ibm = ibm.kms
  }
  count                       = var.enable_kms_encryption && var.existing_kms_key_crn == null ? 1 : 0 # create KMS resources only when encryption is enabled and no existing key is provided
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "5.6.3"
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
  depends_on                    = [time_sleep.wait_for_authorization_policy]
  source                        = "../../"
  region                        = var.region
  plan                          = var.service_plan
  resource_group_id             = module.resource_group.resource_group_id
  watsonx_data_name             = var.watsonx_data_instance_name != null ? "${local.prefix}${var.watsonx_data_instance_name}" : null
  access_tags                   = var.access_tags
  resource_tags                 = var.resource_tags
  use_case                      = var.service_plan == "lite" ? var.lite_plan_use_case : null
  enable_kms_encryption         = var.enable_kms_encryption
  skip_iam_authorization_policy = var.skip_watsonx_data_kms_iam_auth_policy
  watsonx_data_kms_key_crn      = local.kms_key_crn
}
