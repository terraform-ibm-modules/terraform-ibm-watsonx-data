#######################################################################################################################
# Local Variables
#######################################################################################################################

locals {

  # watsonx.data values
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok",
    "au-syd"   = "ibm:au-syd:syd",
    "ca-tor"   = "ibm:ca-tor:tor",
    "us-east"  = "ibm:us-east:wdc"
  }

  watsonx_data_datacenter = local.watsonx_data_datacenter_mapping[var.region]
  account_id              = var.existing_watsonx_data_instance_crn != null ? module.crn_parser[0].account_id : ibm_resource_instance.data_instance[0].account_id
  watsonx_data_id         = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_data_instance[0].id : ibm_resource_instance.data_instance[0].id
  watsonx_data_crn        = var.existing_watsonx_data_instance_crn != null ? var.existing_watsonx_data_instance_crn : resource.ibm_resource_instance.data_instance[0].crn
  watsonx_data_guid       = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_data_instance[0].guid : resource.ibm_resource_instance.data_instance[0].guid
  watsonx_data_name       = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_data_instance[0].resource_name : resource.ibm_resource_instance.data_instance[0].resource_name
  watsonx_data_plan_id    = var.existing_watsonx_data_instance_crn != null ? null : resource.ibm_resource_instance.data_instance[0].resource_plan_id
  # Temporary workaround for issue 13341[https://github.ibm.com/GoldenEye/issues/issues/13341]
  watsonx_data_dashboard_url = "https://cloud.ibm.com/services/lakehouse/${urlencode(local.watsonx_data_crn)}"

  # Use lakehouse-enterprise-mcsp if region is au-syd or ca-tor with lakehouse-enterprise plan
  enterprise_plan_type = (var.plan == "lakehouse-enterprise" && contains(["au-syd", "ca-tor"], var.region)) ? "lakehouse-enterprise-mcsp" : var.plan
}


module "crn_parser" {
  count   = var.existing_watsonx_data_instance_crn != null ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.4.1"
  crn     = var.existing_watsonx_data_instance_crn
}

module "kms_key_crn_parser" {
  count   = var.enable_kms_encryption ? 1 : 0
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.4.1"
  crn     = var.watsonx_data_kms_key_crn
}

# KMS values
locals {
  # kms not applicable for plan - `lakehouse-enterprise-mcsp`
  validate_kms_plan           = local.enterprise_plan_type == "lakehouse-enterprise" && var.watsonx_data_kms_key_crn != null
  kms_service                 = local.validate_kms_plan ? try(module.kms_key_crn_parser[0].service_name, null) : null
  kms_account_id              = local.validate_kms_plan ? try(module.kms_key_crn_parser[0].account_id, null) : null
  kms_key_id                  = local.validate_kms_plan ? try(module.kms_key_crn_parser[0].resource, null) : null
  target_resource_instance_id = local.validate_kms_plan ? try(module.kms_key_crn_parser[0].service_instance, null) : null

}
########################################################################################################################
# watsonx.data
########################################################################################################################

data "ibm_resource_instance" "existing_data_instance" {
  count      = var.existing_watsonx_data_instance_crn != null ? 1 : 0
  identifier = var.existing_watsonx_data_instance_crn
}

resource "ibm_resource_instance" "data_instance" {
  count             = var.existing_watsonx_data_instance_crn != null ? 0 : 1
  name              = var.watsonx_data_name
  service           = "lakehouse"
  plan              = local.enterprise_plan_type
  location          = var.region
  resource_group_id = var.resource_group_id
  tags              = var.resource_tags

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  parameters = {
    datacenter : local.watsonx_data_datacenter
    cloud_type : "ibm"
    region : var.region
    use_case : var.use_case
    kms_instance : var.watsonx_data_kms_key_crn
    kms_key : local.kms_key_id
  }
}

##############################################################################
# Attach Access Tags
##############################################################################

resource "ibm_resource_tag" "watsonx_data_tag" {
  count       = length(var.access_tags) != 0 ? 1 : 0
  resource_id = local.watsonx_data_crn
  tags        = var.access_tags
  tag_type    = "access"
}

##############################################################################
# IAM Authorization Policy
##############################################################################

resource "ibm_iam_authorization_policy" "kms_policy" {
  count                       = !var.enable_kms_encryption || var.skip_iam_authorization_policy ? 0 : 1
  source_service_name         = "lakehouse"
  source_resource_instance_id = ibm_resource_instance.data_instance[0].guid
  roles                       = ["Reader"]
  resource_attributes {
    name     = "serviceName"
    operator = "stringEquals"
    value    = local.kms_service
  }
  resource_attributes {
    name     = "accountId"
    operator = "stringEquals"
    value    = local.kms_account_id
  }
  resource_attributes {
    name     = "serviceInstance"
    operator = "stringEquals"
    value    = local.target_resource_instance_id
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

# workaround for https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4478
resource "time_sleep" "wait_for_kms_authorization_policy" {
  count           = !var.enable_kms_encryption || var.skip_iam_authorization_policy ? 0 : 1
  depends_on      = [ibm_iam_authorization_policy.kms_policy]
  create_duration = "30s"
}
