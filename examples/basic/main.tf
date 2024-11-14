locals {
  unique_identifier = random_string.unique_identifier.result
}

# Access random string generated with random_string.unique_identifier.result
resource "random_string" "unique_identifier" {
  length  = 6
  special = false
  upper   = false
}


module "watsonx_data" {
  source                      = "../../"
  resource_prefix             = "basic-test-${local.unique_identifier}"
  location                    = var.location
  use_existing_resource_group = "false"
  resource_group_name         = local.unique_identifier
  watsonx_data_plan           = "lite"
}
