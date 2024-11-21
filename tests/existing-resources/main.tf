locals {
  watsonx_data_datacenter_mapping = {
    "us-south" = "ibm:us-south:dal",
    "eu-gb"    = "ibm:eu-gb:lon",
    "eu-de"    = "ibm:eu-de:fra",
    "jp-tok"   = "ibm:jp-tok:tok",
    "au-syd"   = "ibm:au-syd:syd"
  }
  watsonx_data_datacenter = local.watsonx_data_datacenter_mapping[var.region]
}
module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

resource "ibm_resource_instance" "data_instance" {
  name              = "${var.prefix}-watsonx-data"
  service           = "lakehouse"
  plan              = "lite"
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  parameters = {
    datacenter : local.watsonx_data_datacenter
    cloud_type : "ibm"
    region : var.region
    use_case : "ai"
  }
}
