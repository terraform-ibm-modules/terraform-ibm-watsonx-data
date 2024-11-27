########################################################################################################################
# Outputs
########################################################################################################################

output "watsonx_data_crn" {
  description = "The CRN of the watsonx.data instance."
  value       = module.watsonx_data.watsonx_data_crn
}

output "watsonx_data_dashboard_url" {
  description = "The dashboard URL of the watsonx.data."
  value       = module.watsonx_data.watsonx_data_dashboard_url
}

output "watsonx_data_guid" {
  description = "The GUID of the watsonx.data instance."
  value       = module.watsonx_data.watsonx_data_guid
}

output "watsonx_data_name" {
  description = "The name of the watsonx.data instance."
  value       = module.watsonx_data.watsonx_data_name
}

output "watsonx_data_plan_id" {
  description = "The plan ID of the watsonx.data instance."
  value       = module.watsonx_data.watsonx_data_plan_id
}

output "resource_group_id" {
  description = "The resource group ID to provision the watsonx.data instance."
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "The resource group name to provision the watsonx.data instance."
  value       = module.resource_group.resource_group_name
}
