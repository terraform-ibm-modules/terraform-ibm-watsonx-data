########################################################################################################################
# watsonx.data
########################################################################################################################

module "existing_watsonx_data_instance" {
  source                             = "../../"
  access_tags                        = var.access_tags
  existing_watsonx_data_instance_crn = var.existing_watsonx_data_instance_crn
  skip_iam_authorization_policy      = true
}
