#######################################################################################################################
# Local Variables
#######################################################################################################################

locals {
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok",
    "au-syd"   = "ibm:au-syd:syd"
  }
  watsonx_data_datacenter    = local.watsonx_data_datacenter_mapping[var.region]
  watsonx_data_crn           = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_watsonx_data_instance[0].crn : resource.ibm_resource_instance.data_instance[0].crn
  watsonx_data_guid          = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_watsonx_data_instance[0].guid : resource.ibm_resource_instance.data_instance[0].guid
  watsonx_data_name          = var.existing_watsonx_data_instance_crn != null ? data.ibm_resource_instance.existing_watsonx_data_instance[0].resource_name : resource.ibm_resource_instance.data_instance[0].resource_name
  watsonx_data_plan_id       = var.existing_watsonx_data_instance_crn != null ? null : resource.ibm_resource_instance.data_instance[0].resource_plan_id
  watsonx_data_dashboard_url = var.existing_watsonx_data_instance_crn != null ? null : resource.ibm_resource_instance.data_instance[0].dashboard_url
}

########################################################################################################################
# Watsonx Data Instance
########################################################################################################################

data "ibm_resource_instance" "existing_watsonx_data_instance" {
  count      = var.existing_watsonx_data_instance_crn != null ? 1 : 0
  identifier = var.existing_watsonx_data_instance_crn
}

resource "ibm_resource_instance" "data_instance" {
  count             = var.existing_watsonx_data_instance_crn != null ? 0 : 1
  name              = var.watsonx_data_name
  service           = "lakehouse"
  plan              = var.watsonx_data_plan
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
    use_case : "ai"
  }
}

##############################################################################
# Attach Access Tags
##############################################################################

resource "ibm_resource_tag" "watsonx_data_tag" {
  count       = length(var.access_tags) == 0 ? 0 : 1
  resource_id = ibm_resource_instance.data_instance[0].crn
  tags        = var.access_tags
  tag_type    = "access"
}
