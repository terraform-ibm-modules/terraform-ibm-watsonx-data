#######################################################################################################################
# Local Variables
#######################################################################################################################

locals {
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok"
  }
  watsonx_data_datacenter    = local.watsonx_data_datacenter_mapping[var.location]
  watsonx_data_crn           = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].crn : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].crn : null
  watsonx_data_guid          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].guid : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].guid : null
  watsonx_data_name          = var.existing_data_instance != null ? data.ibm_resource_instance.existing_data_instance[0].resource_name : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_name : null
  watsonx_data_plan_id       = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].resource_plan_id : null
  watsonx_data_dashboard_url = var.existing_data_instance != null ? null : var.watsonx_data_plan != "do not install" ? resource.ibm_resource_instance.data_instance[0].dashboard_url : null
}

########################################################################################################################
# Watsonx Data Instance
########################################################################################################################

data "ibm_resource_instance" "existing_data_instance" {
  count      = var.existing_data_instance != null ? 1 : 0
  identifier = var.existing_data_instance
}

resource "ibm_resource_instance" "data_instance" {
  count             = var.existing_data_instance != null ? 0 : var.watsonx_data_plan == "do not install" ? 0 : 1
  name              = var.watsonx_data_name
  service           = "lakehouse"
  plan              = var.watsonx_data_plan
  location          = var.location
  resource_group_id = var.resource_group_id

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  parameters = {
    datacenter : local.watsonx_data_datacenter
    cloud_type : "ibm"
    region : var.location
    use_case : "ai"
  }
}
