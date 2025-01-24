########################################################################################################################
# Outputs
########################################################################################################################

output "account_id" {
  description = "Account ID of the watsonx.data instance"
  value       = module.watsonx_data.account_id
}

output "crn" {
  description = "CRN of the watsonx.data instance."
  value       = module.watsonx_data.crn
}

output "dashboard_url" {
  description = "The dashboard URL of the watsonx.data instance."
  value       = module.watsonx_data.dashboard_url
}

output "guid" {
  description = "GUID of the watsonx.data instance."
  value       = module.watsonx_data.guid
}

output "name" {
  description = "Name of the watsonx.data instance."
  value       = module.watsonx_data.name
}

output "plan_id" {
  description = "The plan ID of the watsonx.data instance."
  value       = module.watsonx_data.plan_id
}

output "resource_group_id" {
  description = "The resource group ID to provision the watsonx.data instance."
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "The resource group name to provision the watsonx.data instance."
  value       = module.resource_group.resource_group_name
}
