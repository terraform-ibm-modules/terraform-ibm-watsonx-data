########################################################################################################################
# Outputs
########################################################################################################################

output "account_id" {
  description = "Account ID of the existing watsonx.data instance"
  value       = module.existing_watsonx_data_instance.account_id
}

output "crn" {
  description = "CRN of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.crn
}

output "id" {
  description = "ID of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.id
}

output "guid" {
  description = "GUID of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.guid
}

output "name" {
  description = "Name of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.name
}
