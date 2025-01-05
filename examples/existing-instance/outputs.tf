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

output "dashboard_url" {
  description = "The dashboard URL of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.dashboard_url
}

output "guid" {
  description = "GUID of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.guid
}

output "name" {
  description = "Name of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.name
}

output "plan_id" {
  description = "The plan ID of the existing watsonx.data instance."
  value       = module.existing_watsonx_data_instance.plan_id
}
