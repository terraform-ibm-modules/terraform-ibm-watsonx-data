########################################################################################################################
# Outputs
########################################################################################################################

output "watsonx_data_name" {
  description = "The CRN of the watsonx.data instance."
  value       = module.existing_watsonx_data_instance.watsonx_data_name
}
